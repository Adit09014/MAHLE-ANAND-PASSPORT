import sqlTedious from "mssql";

export const sql = sqlTedious;

declare global {
  // eslint-disable-next-line no-var
  var _mssqlPool: sqlTedious.ConnectionPool | undefined;
}

export async function getPool(): Promise<sqlTedious.ConnectionPool> {
  if (globalThis._mssqlPool && globalThis._mssqlPool.connected) {
    return globalThis._mssqlPool;
  }

  const isTrusted = (process.env.MSSQL_TRUSTED_CONNECTION || "true") === "true";
  const rawServer = (process.env.MSSQL_SERVER || "localhost\\MSSQLSERVER1").trim();
  const database = (process.env.MSSQL_DATABASE || "GrowthPortal").trim();

  if (isTrusted) {
    // Windows Authentication via msnodesqlv8 native driver
    const sqlNativeModule = await import("mssql/msnodesqlv8.js");
    const sqlNative = (sqlNativeModule as any).default || sqlNativeModule;

    const odbcDrivers = [
      "ODBC Driver 18 for SQL Server",
      "ODBC Driver 17 for SQL Server",
      "SQL Server",
      "SQL Server Native Client 11.0",
    ];

    let lastErr: any = null;
    for (const driver of odbcDrivers) {
      try {
        const trustCert = driver.includes("18") ? "TrustServerCertificate=yes;" : "";
        const tryConfig = {
          driver: "msnodesqlv8",
          connectionString: `Driver={${driver}};Server=${rawServer};Database=${database};Trusted_Connection=yes;${trustCert}`,
          parseJSON: true,
        } as unknown as sqlTedious.config;
        
        const pool = new (sqlNative as any).ConnectionPool(tryConfig);
        globalThis._mssqlPool = await pool.connect();
        return globalThis._mssqlPool!;
      } catch (err) {
        lastErr = err;
      }
    }
    throw lastErr;
  } else {
    // SQL Server Authentication via Tedious / TCP (Username + Password)
    const normalizedServer = rawServer.replace(/\\+/g, "\\");
    let serverHost = normalizedServer;
    let instanceName: string | undefined = undefined;

    if (normalizedServer.includes("\\")) {
      const parts = normalizedServer.split("\\").filter(Boolean);
      serverHost = parts[0] || "localhost";
      instanceName = parts[1] || undefined;
    }

    const user = (process.env.MSSQL_USER || "").trim().replace(/^["']|["']$/g, "");
    const password = (process.env.MSSQL_PASSWORD || "").trim().replace(/^["']|["']$/g, "");

    const config: sqlTedious.config = {
      server: serverHost,
      database,
      user,
      password,
      port: process.env.MSSQL_PORT ? parseInt(process.env.MSSQL_PORT, 10) : undefined,
      options: {
        encrypt: process.env.MSSQL_ENCRYPT === "true",
        trustServerCertificate: true,
        enableArithAbort: true,
        ...(instanceName ? { instanceName } : {}),
      },
    };

    try {
      globalThis._mssqlPool = await new sqlTedious.ConnectionPool(config).connect();
      return globalThis._mssqlPool!;
    } catch (err) {
      globalThis._mssqlPool = undefined;
      throw err;
    }
  }
}

export default getPool;
