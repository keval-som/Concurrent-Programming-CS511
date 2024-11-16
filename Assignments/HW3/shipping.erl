-module(shipping).

-compile(export_all).

-include_lib("./shipping.hrl").

get_ship(Shipping_State, Ship_ID) ->
    ShipList = Shipping_State#shipping_state.ships,
    case lists:keyfind(Ship_ID, #ship.id, ShipList) of
        false ->
            throw({error, "Ship not found"});
        Ship ->
            Ship
    end.

get_container(Shipping_State, Container_ID) ->
    ContainerList = Shipping_State#shipping_state.containers,
    case lists:keyfind(Container_ID, #container.id, ContainerList) of
        false ->
            throw(error);
        Container ->
            Container
    end.

get_port(Shipping_State, Port_ID) ->
    PortList = Shipping_State#shipping_state.ports,
    case lists:keyfind(Port_ID, #port.id, PortList) of
        false ->
            throw({error, "Port not found"});
        Port ->
            Port
    end.

get_occupied_docks(Shipping_State, Port_ID) ->
    DockList =
        lists:filter(fun(X) -> element(1, X) == Port_ID end,
                     Shipping_State#shipping_state.ship_locations),
    PortList = [],
    [lists:append(PortList, element(2, Ports)) || Ports <- DockList].

get_ship_location(Shipping_State, Ship_ID) ->
    case lists:keyfind(Ship_ID, 3, Shipping_State#shipping_state.ship_locations) of
        false ->
            throw({error, "Ship not found"});
        {Port_ID, Dock_ID, _} ->
            {Port_ID, Dock_ID}
    end.

get_container_weight(Shipping_State, Container_IDs) ->
    try
        ContainersList =
            [get_container(Shipping_State, Container_ID) || Container_ID <- Container_IDs],
        lists:foldl(fun(X, Acc) -> X#container.weight + Acc end, 0, ContainersList)
    catch
        _:_ ->
            throw({error, "Container Id does not exist"})
    end.

get_ship_weight(Shipping_State, Ship_ID) ->
    try
        ShipContainers = Shipping_State#shipping_state.ship_inventory,
        ContainersList = maps:get(Ship_ID, ShipContainers),
        get_container_weight(Shipping_State, ContainersList)
    catch
        _:_ ->
            throw({error, "Ship does not exist"})
    end.

load_ship(Shipping_State, Ship_ID, Container_IDs) ->
    try
        ShipInventory = Shipping_State#shipping_state.ship_inventory,
        ShipContainersList = maps:get(Ship_ID, ShipInventory),
        {ShipLocation, _} = get_ship_location(Shipping_State, Ship_ID),
        PortInventory = Shipping_State#shipping_state.port_inventory,
        PortContainersList = maps:get(ShipLocation, PortInventory),

        case is_sublist(PortContainersList, Container_IDs) of
            true ->
                ok;
            false ->
                throw("Container not in port")
        end,
        case lists:any(fun(X) -> lists:member(X, ShipContainersList) end, Container_IDs) of
            true ->
                throw("Container inside ship already");
            false ->
                ok
        end,

        Ship = get_ship(Shipping_State, Ship_ID),
        TotalCap = length(Container_IDs) + length(ShipContainersList),
        case TotalCap > Ship#ship.container_cap of
            true ->
                throw("Ship Overloaded");
            false ->
                ok
        end,
        UpdatedShipInventory =
            maps:update(Ship_ID,
                        lists:append(ShipContainersList, Container_IDs),
                        Shipping_State#shipping_state.ship_inventory),
        UpdatedShippingState =
            Shipping_State#shipping_state{ship_inventory = UpdatedShipInventory},
        UpdatedPortInventory =
            maps:update(ShipLocation,
                        lists:subtract(PortContainersList, Container_IDs),
                        Shipping_State#shipping_state.port_inventory),
        UpdatedShippingState2 =
            UpdatedShippingState#shipping_state{port_inventory = UpdatedPortInventory},
        UpdatedShippingState2
    catch
        _:Reason ->
            throw({error, Reason})
    end.

unload_ship_all(Shipping_State, Ship_ID) ->
    try
        ShipInventory = Shipping_State#shipping_state.ship_inventory,
        ShipContainersList = maps:get(Ship_ID, ShipInventory),
        {ShipLocation, _} = get_ship_location(Shipping_State, Ship_ID),
        PortInventory = Shipping_State#shipping_state.port_inventory,
        PortContainersList = maps:get(ShipLocation, PortInventory),
        PortsList = Shipping_State#shipping_state.ports,
        Port = lists:keyfind(ShipLocation, #port.id, PortsList),
        Container_Cap = Port#port.container_cap,
        TotalCap = length(PortContainersList) + length(ShipContainersList),
        case TotalCap > Container_Cap of
            true ->
                throw(error);
            false ->
                ok
        end,
        UpdatedShipInventory =
            maps:update(Ship_ID,
                        lists:subtract(ShipContainersList, ShipContainersList),
                        Shipping_State#shipping_state.ship_inventory),
        UpdatedShippingState =
            Shipping_State#shipping_state{ship_inventory = UpdatedShipInventory},
        UpdatedPortInventory =
            maps:update(ShipLocation,
                        lists:append(PortContainersList, ShipContainersList),
                        Shipping_State#shipping_state.port_inventory),
        UpdatedShippingState2 =
            UpdatedShippingState#shipping_state{port_inventory = UpdatedPortInventory},
        UpdatedShippingState2
    catch
        _:_ ->
            throw(error)
    end.

unload_ship(Shipping_State, Ship_ID, Container_IDs) ->
    try
        ShipInventory = Shipping_State#shipping_state.ship_inventory,
        ShipContainersList = maps:get(Ship_ID, ShipInventory),
        case is_sublist(ShipContainersList, Container_IDs) of
            true ->
                ok;
            false ->
                throw(error)
        end,
        {ShipLocation, _} = get_ship_location(Shipping_State, Ship_ID),
        PortInventory = Shipping_State#shipping_state.port_inventory,
        PortContainersList = maps:get(ShipLocation, PortInventory),
        PortsList = Shipping_State#shipping_state.ports,
        Port = lists:keyfind(ShipLocation, #port.id, PortsList),
        Container_Cap = Port#port.container_cap,
        TotalCap = length(PortContainersList) + length(Container_IDs),
        case TotalCap > Container_Cap of
            true ->
                throw(error);
            false ->
                ok
        end,
        UpdatedShipInventory =
            maps:update(Ship_ID,
                        lists:subtract(ShipContainersList, Container_IDs),
                        Shipping_State#shipping_state.ship_inventory),
        UpdatedShippingState =
            Shipping_State#shipping_state{ship_inventory = UpdatedShipInventory},
        UpdatedPortInventory =
            maps:update(ShipLocation,
                        lists:append(PortContainersList, Container_IDs),
                        Shipping_State#shipping_state.port_inventory),
        UpdatedShippingState2 =
            UpdatedShippingState#shipping_state{port_inventory = UpdatedPortInventory},
        UpdatedShippingState2
    catch
        _:_ ->
            throw(error)
    end.

set_sail(Shipping_State, Ship_ID, {Port_ID, Dock}) ->
    {CurrentPort, CurrentDoc} = get_ship_location(Shipping_State, Ship_ID),
    case {CurrentDoc, CurrentPort} of
        {Dock, Port_ID} ->
            throw(error);
        _ ->
            ok
    end,
    OccupiedDocks = get_occupied_docks(Shipping_State, Port_ID),
    case lists:member(Dock, OccupiedDocks) of
        true ->
            throw(error);
        false ->
            ok
    end,
    ShipLocations = Shipping_State#shipping_state.ship_locations,
    ShipSail = {Port_ID, Dock, Ship_ID},
    UpdatedShipLocations = lists:keyreplace(Ship_ID, 3, ShipLocations, ShipSail),
    UpdatedShippingState =
        Shipping_State#shipping_state{ship_locations = UpdatedShipLocations},
    UpdatedShippingState.

%% Determines whether all of the elements of Sub_List are also elements of Target_List
%% @returns true is all elements of Sub_List are members of Target_List; false otherwise
is_sublist(Target_List, Sub_List) ->
    lists:all(fun(Elem) -> lists:member(Elem, Target_List) end, Sub_List).

%% Prints out the current shipping state in a more friendly format
print_state(Shipping_State) ->
    io:format("--Ships--~n"),
    _ = print_ships(Shipping_State#shipping_state.ships,
                    Shipping_State#shipping_state.ship_locations,
                    Shipping_State#shipping_state.ship_inventory,
                    Shipping_State#shipping_state.ports),
    io:format("--Ports--~n"),
    _ = print_ports(Shipping_State#shipping_state.ports,
                    Shipping_State#shipping_state.port_inventory).

%% helper function for print_ships
get_port_helper([], _Port_ID) ->
    error;
get_port_helper([Port = #port{id = Port_ID} | _], Port_ID) ->
    Port;
get_port_helper([_ | Other_Ports], Port_ID) ->
    get_port_helper(Other_Ports, Port_ID).

print_ships(Ships, Locations, Inventory, Ports) ->
    case Ships of
        [] ->
            ok;
        [Ship | Other_Ships] ->
            {Port_ID, Dock_ID, _} = lists:keyfind(Ship#ship.id, 3, Locations),
            Port = get_port_helper(Ports, Port_ID),
            {ok, Ship_Inventory} = maps:find(Ship#ship.id, Inventory),
            io:format("Name: ~s(#~w)    Location: Port ~s, Dock ~s    Inventory: ~w~n",
                      [Ship#ship.name, Ship#ship.id, Port#port.name, Dock_ID, Ship_Inventory]),
            print_ships(Other_Ships, Locations, Inventory, Ports)
    end.

print_containers(Containers) ->
    io:format("~w~n", [Containers]).

print_ports(Ports, Inventory) ->
    case Ports of
        [] ->
            ok;
        [Port | Other_Ports] ->
            {ok, Port_Inventory} = maps:find(Port#port.id, Inventory),
            io:format("Name: ~s(#~w)    Docks: ~w    Inventory: ~w~n",
                      [Port#port.name, Port#port.id, Port#port.docks, Port_Inventory]),
            print_ports(Other_Ports, Inventory)
    end.

%% This functions sets up an initial state for this shipping simulation. You can add, remove, or modidfy any of this content. This is provided to you to save some time.
%% @returns {ok, shipping_state} where shipping_state is a shipping_state record with all the initial content.
shipco() ->
    Ships =
        [#ship{id = 1,
               name = "Santa Maria",
               container_cap = 20},
         #ship{id = 2,
               name = "Nina",
               container_cap = 20},
         #ship{id = 3,
               name = "Pinta",
               container_cap = 20},
         #ship{id = 4,
               name = "SS Minnow",
               container_cap = 20},
         #ship{id = 5,
               name = "Sir Leaks-A-Lot",
               container_cap = 20}],
    Containers =
        [#container{id = 1, weight = 200}, #container{id = 2, weight = 215},
         #container{id = 3, weight = 131}, #container{id = 4, weight = 62},
         #container{id = 5, weight = 112}, #container{id = 6, weight = 217},
         #container{id = 7, weight = 61}, #container{id = 8, weight = 99},
         #container{id = 9, weight = 82}, #container{id = 10, weight = 185},
         #container{id = 11, weight = 282}, #container{id = 12, weight = 312},
         #container{id = 13, weight = 283}, #container{id = 14, weight = 331},
         #container{id = 15, weight = 136}, #container{id = 16, weight = 200},
         #container{id = 17, weight = 215}, #container{id = 18, weight = 131},
         #container{id = 19, weight = 62}, #container{id = 20, weight = 112},
         #container{id = 21, weight = 217}, #container{id = 22, weight = 61},
         #container{id = 23, weight = 99}, #container{id = 24, weight = 82},
         #container{id = 25, weight = 185}, #container{id = 26, weight = 282},
         #container{id = 27, weight = 312}, #container{id = 28, weight = 283},
         #container{id = 29, weight = 331}, #container{id = 30, weight = 136}],
    Ports =
        [#port{id = 1,
               name = "New York",
               docks = ['A', 'B', 'C', 'D'],
               container_cap = 200},
         #port{id = 2,
               name = "San Francisco",
               docks = ['A', 'B', 'C', 'D'],
               container_cap = 200},
         #port{id = 3,
               name = "Miami",
               docks = ['A', 'B', 'C', 'D'],
               container_cap = 200}],
    %% {port, dock, ship}
    Locations = [{1, 'B', 1}, {1, 'A', 3}, {3, 'C', 2}, {2, 'D', 4}, {2, 'B', 5}],
    Ship_Inventory =
        #{1 => [14, 15, 9, 2, 6],
          2 => [1, 3, 4, 13],
          3 => [],
          4 => [2, 8, 11, 7],
          5 => [5, 10, 12]},
    Port_Inventory =
        #{1 => [16, 17, 18, 19, 20],
          2 => [21, 22, 23, 24, 25],
          3 => [26, 27, 28, 29, 30]},
    #shipping_state{ships = Ships,
                    containers = Containers,
                    ports = Ports,
                    ship_locations = Locations,
                    ship_inventory = Ship_Inventory,
                    port_inventory = Port_Inventory}.
