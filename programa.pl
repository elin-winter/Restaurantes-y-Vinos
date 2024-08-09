%%%%%%%%%%%%%%%%%%%%%% Restaurantes y Vinos %%%%%%%%%%%%%%%%%%%%

restaurante(panchoMayo, 2, barracas).
restaurante(finoli, 3, villaCrespo).
restaurante(superFinoli, 5, villaCrespo).

menu(panchoMayo, carta(1000, pancho)).
menu(panchoMayo, carta(200, hamburguesa)).
menu(finoli, carta(2000, hamburguesa)).
menu(finoli, pasos(15, 15000, [chateauMessi, francescoliSangiovese, susanaBalboaMalbec], 6)).
menu(noTanFinoli, pasos(2, 3000, [guinoPin, juanaDama],3)).

vino(chateauMessi, francia, 5000).
vino(francescoliSangiovese, italia, 1000).
vino(susanaBalboaMalbec, argentina, 1200).
vino(christineLagardeCabernet, argentina, 5200).
vino(guinoPin, argentina, 500).
vino(juanaDama, argentina, 1000).

%%%%%%%%%%%%%%%%% Punto 1

restosMasDeNEstrellas(Estrellas, Barrio, Restos):-
    findall(Resto, 
        (restaurante(Resto, Estrella, Barrio), 
        Estrella >= Estrellas), 
        Restos).

restoMasDeNEstrellas(Estrellas, Barrio, Resto):-
    restaurante(Resto, Estrella, Barrio),
    Estrella >= Estrellas.

%%%%%%%%%%%%%%%%% Punto 2
restoSinEstrellas(Resto):-
    menu(Resto, _),
    not(restaurante(Resto, _, _)).

%%%%%%%%%%%%%%%%% Punto 3
malOrganizado(Resto):-
    menu(Resto, pasos(CantPasos, _, ListaVinos, _)), 
    length(ListaVinos, CantVinos),
    CantPasos > CantVinos.

malOrganizado(Resto):-
    menu(Resto, carta(Precio1, Plato)),
    menu(Resto, carta(Precio2, Plato)),
    Precio1 \= Precio2.

%%%%%%%%%%%%%%%%% Punto 4
copiaBarata(Copia, Original):-
    restoMenosEstrellas(Copia, Original),
    mismoPlatoMenosPrecio(Copia, Original).

restoMenosEstrellas(Copia, Original):-
    restaurante(Copia, EC, _),
    restaurante(Original, EO, _),
    Copia \= Original,
    EO > EC.

mismoPlatoMenosPrecio(Copia, Original):-
    forall(menu(Original, carta(PrecioOri, Plato)), 
        (menu(Copia, carta(PrecioCopi, Plato)), PrecioOri > PrecioCopi)).    

%%%%%%%%%%%%%%%%% Punto 5
precioPromedioMenu(Resto, PrecioFinal):-
    findall(Precio, menu(Resto, carta(Precio, _)), Precios),
    length(Precios, CantPlatos),
    CantPlatos > 0,  
    sumlist(Precios, PrecioComida),
    PrecioFinal is PrecioComida / CantPlatos.

precioPromedioMenuPasos(Resto, PrecioFinal):-
    menu(Resto, pasos(_, Precio, ListaVinos, CantComensales)),
    CantComensales > 0,  
    findall(PrecioVino, (member(Vino, ListaVinos), precioVino(Vino, PrecioVino)), PreciosVinos),
    sumlist(PreciosVinos, CostoPorVino),
    PrecioFinal is (Precio + CostoPorVino) / CantComensales.
    
precioVino(NombreVino, Precio):-
    vino(NombreVino, argentina, Precio).

precioVino(NombreVino, Precio):-
    vino(NombreVino,Pais,P),
    Pais \= argentina,
    Precio is P * 1.35.

/*
% Precio promedio final de un menú, combinando todos los precios
precioPromedioMenu(Resto, PrecioFinal):-
    findall(Precio, precioCarta(Resto, Precio), PreciosCartas),
    findall(Precio, precioPasos(Resto, Precio), PreciosPasos),
    append(PreciosCartas, PreciosPasos, TodosLosPrecios),
    length(TodosLosPrecios, CantMenus),
    CantMenus > 0,
    sumlist(TodosLosPrecios, PrecioTotal),
    PrecioFinal is PrecioTotal / CantMenus.

% Precio de un menú de tipo carta
precioCarta(Resto, PrecioCarta):-
    menu(Resto, carta(PrecioCarta, _)).

% Precio de un menú de tipo pasos
precioPasos(Resto, PrecioPasos):-
    menu(Resto, pasos(_, Precio, ListaVinos, CantComensales)),
    CantComensales > 0,
    precioTotalVinos(ListaVinos, CostoPorVino),
    PrecioPasos is (Precio + CostoPorVino) / CantComensales.

% Precio total de una lista de vinos
precioTotalVinos(ListaVinos, CostoTotal):-
    findall(PrecioVino, (member(Vino, ListaVinos), precioVino(Vino, PrecioVino)), PreciosVinos),
    sumlist(PreciosVinos, CostoTotal).

*/

%%%%%%%%%%%%%%%%% Punto 6

menu(cafeRiz, takeaway(avion, cortado)).
menu(cafeRiz, takeaway(motoneta, latte)).
menu(cafeRiz, takeaway(monopatin, medialunas)).

menu(lunaCafe, takeaway(motoneta, cortado)).

precio(avion, 922829292).
precio(motoneta, 10).
precio(monopatin, 25).

precioPromedioMenu(Resto, PrecioFinal):-
    findall(Precio, (menu(Resto, takeaway(Modo, _)), precio(Modo, Precio)), Precios),
    length(Precios, CantPlatos),
    CantPlatos > 0,  
    sumlist(Precios, PrecioComida),
    PrecioFinal is PrecioComida / CantPlatos.

malOrganizado(Resto):-
    menu(Resto1, takeaway(Modo1, Elemento)),
    menu(Resto2, takeaway(Modo2, Elemento)),
    Resto1 \= Resto2, 
    Modo1 \= Modo2,
    precio(Modo1, Precio1), 
    precio(Modo2, Precio2), 
    Precio2 > Precio1.
