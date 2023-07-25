 --Trigger 1 - Passagem
 Create or Replace Function VerificarPassagem()
	 RETURNS trigger AS $$
 	
 	BEGIN
 		IF (TG_OP = 'INSERT') THEN
			IF(select count(cadeira) from passagem where codigo_voo = NEW.codigo_voo) >= 
			(select qtd_assentos from Voo where codigo = NEW.codigo_voo) THEN
				Raise Exception 'Este VOO esta lotado, nao foi possivel comprar passagem';
				RETURN NULL;
		
				
			END IF;
		ELSEIF (TG_OP = 'UPDATE') THEN
			IF (NEW.codigo_voo != OLD.codigo_voo) THEN
				IF(select count(cadeira) from passagem where codigo_voo = NEW.codigo_voo) >= 
					(select qtd_assentos from Voo where codigo = NEW.codigo_voo) THEN
						Raise Exception 'Este VOO esta lotado, nao foi possivel trocar a  passagem';
				RETURN NULL;
				END IF;
			END IF;
		END IF;
	Return NEW;
	END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER ValidarPassagem
    BEFORE INSERT or UPDATE ON Passagem
    FOR EACH ROW
    EXECUTE PROCEDURE VerificarPassagem();
	


/*
INSERT INTO Passagem (codigo_voo,cadeira,valor,data_compra,tipo,CPF_usuario)
VALUES
(1,20,164,'2021/12/3','Econômica','21482303900')
Update passagem set codigo_voo = 1 where codigo_voo = 12 and cadeira = 59

drop trigger ValidarPassagem on Passagem;
drop function VerificarPassagem();
*/

-- Trigger 2 , DATA_destino

CREATE OR REPLACE FUNCTION validarData()
RETURNS trigger AS $$
	BEGIN
		IF (TG_OP = 'INSERT') THEN
			IF (SELECT codigo_aeroporto from Partida where codigo_voo = NEW.codigo_voo) = NEW.codigo_aeroporto THEN
				RAISE EXCEPTION 'Selecione um destino diferente da partida';
				RETURN NULL;
			END IF;
			IF (SELECT data from Partida where codigo_voo = NEW.codigo_voo) = NEW.DATA THEN
				IF(SELECT hora from Partida where codigo_voo = NEW.codigo_voo ) < NEW.hora THEN
					RETURN NEW;
				ELSE
					RAISE EXCEPTION 'Hora invalida,insira uma hora posterior';
					RETURN NULL;
				END IF;	
			END IF;
			IF (SELECT data from Partida where codigo_voo = NEW.codigo_voo) < NEW.DATA THEN
				RETURN NEW;
			ELSE
				RAISE EXCEPTION 'Data incorreta, insira uma data valida';
				RETURN NULL;
			END IF;
		END IF;
	Return NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER validaData
    BEFORE INSERT ON Chegada
    FOR EACH ROW
    EXECUTE PROCEDURE validarData();
/*
drop trigger validaData on Chegada;
drop function validarData();
*/
