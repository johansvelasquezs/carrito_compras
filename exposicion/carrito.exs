defmodule Carrito do
 @moduledoc """
  Modulo que representa un carrito de compras.
  -version 1.0
  -autores: Samuel, Joan, Camilo, Esteban
  -fecha: 21/09/2026
  """

  @doc """
  Funcion principal que inicia la aplicacion del carrito:
  """
  def main do
    carrito = []
    Util.mostrar_mensaje("=== CARRITO DE COMPRAS ===")
    cantidad_productos =
      "Ingrese la cantidad de productos que desea agregar: "
      |> Util.ingresar(:entero)
    carrito = ingresar_productos(carrito, cantidad_productos)
    total = calcular_total(carrito)
    carrito
    |> generar_mensaje(total)
    |> Enum.each(&Util.mostrar_mensaje/1)

  end

  defp ingresar_productos(carrito, 0) do
    carrito
  end

  defp ingresar_productos(carrito, cantidad) do

    nombre =
      "Ingrese el nombre del producto: "
      |> Util.ingresar(:texto)

    precio =
      "Ingrese el precio del producto: "
      |> Util.ingresar(:entero)

    cantidad_producto =
      "Ingrese la cantidad del producto: "
      |> Util.ingresar(:entero)

    producto = crear_producto(nombre, precio, cantidad_producto)

    nuevo_carrito = agregar_producto(carrito, producto)

    ingresar_productos(nuevo_carrito, cantidad - 1)

  end

  
end
