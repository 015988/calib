function L=le_dat_dvideo(nome_arq)
%Esta fun��o converte do formato do dvideo para o formato usado na funcao
%calibra. Ainda cont�m -1 na sa�da.
%Entrada: Nome do arquivo .dat
%Saida: Vetor Nx2 com os pontos da imagem 

%ler o arquivo .dat
buf=textread(nome_arq);

%vamos excluir o primeiro n�mero (nao sei para que serve!)
buf=buf(2:end);
tam=size(buf,2);


%Alocar mem�ria para a sa�da
L=zeros(tam/2,2);
il=1;
for i=1:2:tam
    L(il,:)=[buf(i) buf(i+1)];
    il=il+1;
end
     
    