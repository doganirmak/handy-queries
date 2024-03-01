SELECT 
    s.name AS SchemaName,
    SUM(a.total_pages) * 8 / 1024.0 AS TotalSpaceMB, 
    SUM(a.used_pages) * 8 / 1024.0 AS UsedSpaceMB, 
    (SUM(a.total_pages) - SUM(a.used_pages)) * 8 / 1024.0 AS UnusedSpaceMB
FROM 
    sys.tables t
INNER JOIN      
    sys.indexes i ON t.OBJECT_ID = i.object_id
INNER JOIN 
    sys.partitions p ON i.object_id = p.OBJECT_ID AND i.index_id = p.index_id
INNER JOIN 
    sys.allocation_units a ON p.partition_id = a.container_id
INNER JOIN 
    sys.schemas s ON t.schema_id = s.schema_id
GROUP BY 
    s.name
ORDER BY 
    UsedSpaceMB DESC;