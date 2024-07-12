% 1. PREDICADO not/1 (predicado de orden superior)

humano(socrates). %socrates es humano
par(2). %2 es un numero par
longitud([1,2,3],3).
nacio(melina, fecha(19, 8, 2001)).

% apostadores de ruleta
juega(julia, 3).
juega(beto, 6).
juega(dodain, 5).
juega(juana, 15).
juega(sergio, 3).

% Un numero es yeta <-- si nadie apuesta por el 
%   ∄x / p(x) se cumple

yeta(Numero) :- not(juega(_, Numero)).
% yeta(25) true.
% yeta(3) false.
% yeta(N) false. ----> porque no le dijimos a prolog el universo de numeros que podemos apostar en la ruleta
%                ----> es decir NO es INVERSIBLE

numeroRuleta(Numero) :- between(1, 36, Numero). %seria como un "entre"

yetaINVER(Numero) :-
    numeroRuleta(Numero),
    not(juega(_,Numero)).

% Not es de aridad 1

% debemos hacerlo utilizando paréntesis, para mantener la aridad del not:

% ?- not(10 > 3, juega(dodain, 5)).
% ERROR: Undefined procedure: not/2
% ERROR:     However, there are definitions for:
% ERROR:         not/1
% false.

% ?- not((10 > 3, juega(dodain, 5))).
% false.

% --------------------------------------------

perroFamoso(lassie).
perroFamoso(rintintin).
perroFamoso(benji).
perroFamoso(beethoven).

perroComun(Perro) :- not(perroFamoso(Perro)). % esto esta mal, porque prolog no conoce todos los perros que forman parte del universo
%                                              entonces no puedo saber que perros NO son famosos
% LA VARIABLE PERRO NO ESTA UNIFICADA (LIGADA)
% Puedo preguntar perroComun(lassie) o perroComun(sultan), 
% pero NO puedo preguntar perroComun(Perro). 
% Por eso el predicado perroComun NO es inversible. ¡Sólo sabe los perros famosos, no los comunes!

% solucion 1

perro(salchica).
perro(pastor).

perroComunV1(Perro) :-
    perro(Perro),  %universo de perros (para ligar la variable Perro)
    not(perroFamoso(perro)).

% solucion 2
% Hago los complementos de perros famosos como hechos
perroComun(chicho).
perroComun(sultan).
perroComun(copito).

% --------------------------------------------

% 2. PREDICADO forall/2 (que una condicion se cumpla para todas la variables posibles)

materia(algoritmos, 1).
materia(analisisI, 1).
materia(pdp, 2).
materia(proba, 2).
materia(sintaxis, 2).

nota(nicolas, pdp, 10).
nota(nicolas, proba, 7).
nota(nicolas, sintaxis, 8).

nota(malena, pdp, 6).
nota(malena, proba, 2).

nota(raul, pdp, 9).

% "Un alumno termino un año si aprobo todas las materias de ese año"

terminoAnio(Alumno, Anio) :-
    forall(materia(Materia,Anio), (nota(Alumno,Materia,Nota), Nota >=6)).
%           para el universo de todas las materias de ese año,  si las aprobo

% otra version

alumno(nicolas).
alumno(malena).
alumno(raul).

alumno(Alumno) :- nota(Alumno, _, _). % si tiene nota, es alumno

anio(1).
anio(2).

terminoAnioV2(Alumno, Anio) :-
    alumno(Alumno), % para que la pregunta sea para cada alumno (tiene que ser un alumno)
    anio(Anio),     % unifico tambien el anio (tiene que ser un anio)
    forall(materia(Materia,Anio), aprobo(Alumno, Materia)).

aprobo(Alumno, Materia) :-
    nota(Alumno, Materia, Nota),
    Nota >= 6.

% --------------------------------------------

% auto le viene perfecto = tiene todas las caracterisiticas que la persona quiere

vieneCon(p206, abs).
vieneCon(p206, levantavidrios).
vieneCon(p206, direccionAsistida).

vieneCon(kadisco, abs).
vieneCon(kadisco, mp3).
vieneCon(kadisco, tacometro).

quiere(carlos, abs).
quiere(carlos, mp3).
quiere(roque, abs).
quiere(roque, direccionAsistida).

%persona(Persona) :- quiere(Persona,_). % el que quiere algo, es persona
persona(carlos).
persona(roque).

%auto(Auto) :- vieneCon(Auto, _). % el que viene con algo, es auto
auto(p206).
auto(kadisco).

leVienePerfecto(Auto, Persona) :-
    persona(Persona),   % unifico persona (para cada persona en concreto)
    auto(Auto),         % unifico auto (para cada auto en concreto)
    forall(quiere(Persona,Caracterisitica), vieneCon(Auto,Caracterisitica)).

% SI NO USARIA LA UNIFACION (LIGACION) en las variables, el forall seria:
% Una afirmación general: para todas las personas que quieren algo, existe algún auto que viene con eso

% ------------------------------------------
% 3. Logica de Conjuntos

% INCLUIDO: Un conjunto A está incluido en otro B si todos los elementos de A están en B.
% incluido(A, B) :- 
    % forall(member(X, A), member(X, B)).  % member para saber si un elemento esta dentro de una lista

% DISJUNTOS: Un conjunto A es disjunto de B si se cumple que todos los elementos de A no están en B.
% disjuntos(A, B) :-
    % forall(member(X, A), not(member(X, B))).

% ------------------------------------------

% 4. Del NOT al FORALL

% Si todos los individuos que cumplen p también cumplen q, 
% esto es similar a decir que NO es cierto que exista un individuo que cumpla p que no cumpla q.
% En términos lógicos:
% Si ∀ p(x) ⇒ q(x)  , esto equivale a  ∄ x / p(x) ∧ ¬q(x)

% Y si para todos los individuos que cumplen p ninguno cumple q, 
% esto es lo mismo que decir que no es cierto que exista un individuo que cumpla p y q a la vez.
% Si ∀ p(x) ⇒ ¬q(x)  , esto equivale a  ∄ x / p(x) ∧ q(x)

materia(am1).
materia(sysop).
materia(pdp).

alumnito(clara).
alumnito(matias).
alumnito(valeria).
alumnito(adelmar).

estudio(clara, am1).
estudio(clara, sysop).
estudio(clara, pdp).
estudio(matias, pdp).
estudio(matias, am1).
estudio(valeria, pdp).

% "Un alumno estudioso es aquel que estudia para todas las materias"
estudioso(Alumno) :-
    alumnito(Alumno), % ligo la incognita Alumno
    forall(materia(Materia), estudio(Alumno, Materia)).

% "No es cierto para un alumno estudioso que exista alguna materia en la que NO haya estudiado"

estudiosoNOT(Alumno) :-
    alumnito(Alumno),
    not(((materia(Materia)), not(estudio(Alumno,Materia)))).

% Si por el contrario quiero buscar qué alumnos son difíciles, 
% descriptos como los alumnos que no estudian para ninguna materia, 
% aquí el lector podría considerar la utilización del not:

dificil(Alumno) :-
    alumnito(Alumno),
    not(estudio(Alumno,_)).

% ------------------------------------

% 5. Findall/3

padre(homero, bart).
padre(homero, maggie).
padre(homero, lisa).
padre(juan, fede).
padre(nico, julieta).

persona(Papa) :- padre(Papa, _). % el que es padre, es persona  (por comprension)
persona(Hijo) :- padre(_, Hijo). % el que es hijo, es persona   (por comprension)

% ¿cuántos hijos tiene homero?
cantidadDeHijos(Padre,Cantidad) :-
    persona(Padre), % Generación, así la variable Padre
                    % llega ligada al findall
    findall(Hijo, padre(Padre,Hijo), Hijos),  % tengo multiples respuestas a una consulta y las quiero juntar a esas respuestas en una lista todas juntas
    length(Hijos, Cantidad). % de la lista obtengo la cantidad
    
% ?- cantidadDeHijos(homero, C). 
% C = 3

% findall(UnIndividuoOVariable, Consulta, Conjunto)
% Entonces: findall es un predicado que relaciona 
%   un individuo o variable
%   con una consulta
%   y con el conjunto (lista) de los individuos que satisfacen la consulta.

varon(homero).
varon(juan).
varon(nico).
varon(bart).
varon(fede).

cuantosPibes(Padre,Cantidad) :-
    persona(Padre),
    findall(Hijo,(padre(Padre,Hijo), varon(Hijo)),Varones), % consulta mas compleja
    length(Varones,Cantidad).

% ---------------------------------------

% Interseccion de conjuntos
%interseccion(Xs, Ys, Zs) :-
    % findall(E,(member(E,Xs), member(E,Ys), member(E, Zs)),Zs).

% ---------------------------------------

%-- jugoCon/3: nene, juego, minutos

jugoCon(tobias, pelota, 15).
jugoCon(tobias, bloques, 20).
jugoCon(tobias, rasti, 15).
jugoCon(tobias, dakis, 5).
jugoCon(tobias, casita, 10).

jugoCon(cata, muniecas, 30).
jugoCon(cata, rasti, 20).

jugoCon(luna, muniecas, 10).

nene(Nene) :- jugoCon(Nene, _, _).

% ¿cuantos juegos distintos jugo (NO hay duplicados en la base)
juegosQueJugo(Nene, CantidadJuegos) :-
    nene(Nene), % ligar la varible Nene (el Nene en concreto.... findall)
    findall(Juego, jugoCon(Nene,Juego,_), Juegos),
    length(Juegos, CantidadJuegos).

% ¿cuantos minutos jugo un nene segun la base de conocimientos?
minutosQueJugo(Nene, CantidadMinutos) :-
    nene(Nene), % ligar la varible Nene (el Nene en concreto.... findall)
    findall(Minutos, jugoCon(Nene,_,Minutos), ListaMinutos),
    sumlist(ListaMinutos, CantidadMinutos).
    
% --------------------------------------------
% Usando individuos compuestos en el primer parámetro del findall

% Ejemplo: Imagínense que tenemos una solución donde se define 
% el predicado puntaje/2 que relaciona a un equipo con la cantidad 
% de puntos que tiene. Un requerimiento bastante usual 
% en un programa de este estilo, es conocer la tabla de posiciones 
% que se puede ver como un conjunto de individuos o sea 
% una lista en donde cada individuo que la compone es un equipo con 
% su cantidad de puntos.

% findall(puntos(Equipo, CantidadPuntos), puntaje(Equipo, CantidadPuntos), Tabla).

%   puntos es un functor, no un predicado
%   puntaje es un predicado, no un functor
%   Tabla es una lista de functores puntos que verifican la consulta que está como segundo parámetro del findall

% ----------------------------------------------------------------

tiene(juan, foto([juan, hugo, pedro, lorena, laura], 1988)).
tiene(juan, foto([juan], 1977)).
tiene(juan, libro(saramago, "Ensayo sobre la ceguera")).
tiene(juan, bebiba(whisky)).

tiene(valeria, libro(borges, "Ficciones")).

tiene(lucas, bebiba(cusenier)).

tiene(pedro, foto([juan, hugo, pedro, lorena, laura], 1988)).
tiene(pedro, foto([pedro], 2010)).
tiene(pedro, libro(octavioPaz, "Salamandra")).

premioNobel(octavioPaz).
premioNobel(saramago).

% Determinamos que alguien es coleccionista si todos los elementos que 
% tiene son valiosos:
%   un libro de un premio Nobel es valioso
%   una foto con más de 3 integrantes es valiosa
%   una foto anterior a 1990 es valiosa
%   el whisky es valioso

%persona(Alguien) :- tiene(Alguien, _).
%elemento(Elemento) :- tiene(_, Elemento).

coleccionista(Alguien) :-
    tiene(Alguien, _),  %persona(Alguien),
    forall(tiene(Alguien, Cosa), valioso(Cosa)).
%

valioso(libro(Nobel, _)) :- premioNobel(Nobel).

valioso(foto(Gente, _)) :- length(Gente, Cantidad), Cantidad > 3.

valioso(foto(_, Anio)) :- Anio < 1990.

valioso(bebiba(whisky)).
