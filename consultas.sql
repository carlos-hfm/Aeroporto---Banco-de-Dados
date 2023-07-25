-- Consultas SQL
-- Obs: aqui, as consultas já estão com os valores p/ teste preenchidos

-- Consulta 1
SELECT COUNT(*) AS qtd_voos
FROM Partida
WHERE codigo_aeroporto = 'JUA' AND data = '2022-05-30';


-- Consulta 2
SELECT aeroporto_partida, chegada.codigo_aeroporto AS aeroporto_chegada, data_partida, horario_partida
FROM (SELECT codigo_voo, codigo_aeroporto AS aeroporto_partida, data AS data_partida, hora AS horario_partida
	  FROM (SELECT codigo_voo
			FROM passagem
			WHERE CPF_usuario = '22090117584') AS T1 NATURAL JOIN partida) AS T2 NATURAL JOIN chegada;
			
			
-- Consulta 3
SELECT a.estado, count(a.estado) AS quantidade
FROM aeroporto a JOIN chegada c ON a.codigo = c.codigo_aeroporto
GROUP BY a.estado
ORDER BY quantidade desc;

-- Consulta 4
select a.assentos_livres from (
SELECT generate_series(1, v.qtd_assentos) AS assentos_livres FROM voo v, (
SELECT codigo_voo
FROM partida p1
WHERE codigo_aeroporto = 'VDC' AND "data" = '2021-03-24' AND hora = '10:04:57'
) AS p, (
SELECT codigo_voo
FROM chegada c1
WHERE codigo_aeroporto = 'CAP' AND "data" = '2021-03-24' AND hora = '20:04:57'
) AS c
WHERE v.codigo = p.codigo_voo AND v.codigo = c.codigo_voo
except
SELECT cadeira AS assentos_livres FROM passagem pa, voo v, (
SELECT codigo_voo
FROM partida p1
WHERE codigo_aeroporto = 'VDC' AND "data" = '2021-03-24' AND hora = '10:04:57'
) AS p, (
SELECT codigo_voo
FROM chegada c1
WHERE codigo_aeroporto = 'CAP' AND "data" = '2021-03-24' AND hora = '20:04:57'
) AS c
WHERE v.codigo = p.codigo_voo AND v.codigo = c.codigo_voo AND v.codigo = pa.codigo_voo
) as a order by a.assentos_livres;



-- Consulta 5
SELECT estado, COUNT(codigo) as quant 
FROM Aeroporto
GROUP BY estado ORDER BY estado;


-- Consulta 6
SELECT nome,CPF,cadeira as Assento, tipo 
FROM Usuario,Passagem 
WHERE CPF = CPF_usuario AND codigo_voo = 1;
			
			

