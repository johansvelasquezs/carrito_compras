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
    mostrar_carrito(carrito)
    menu(carrito)
  end

  # --- MENÚ INTERACTIVO ---
  defp menu(carrito) do
    Util.mostrar_mensaje("\n--- MENÚ DE OPCIONES ---")
    Util.mostrar_mensaje("1. Actualizar cantidad de un producto")
    Util.mostrar_mensaje("2. Eliminar un producto")
    Util.mostrar_mensaje("3. Ver carrito y total")
    Util.mostrar_mensaje("4. Salir")

    opcion = "Seleccione una opción: " |> Util.ingresar(:entero)

    case opcion do
      1 ->
        nombre = "Ingrese el nombre del producto a actualizar: " |> Util.ingresar(:texto)
        nueva_cantidad = "Ingrese la nueva cantidad: " |> Util.ingresar(:entero)

        case actualizar_producto(carrito, nombre, nueva_cantidad) do
          {:ok, nuevo_carrito} ->
            Util.mostrar_mensaje("¡Producto actualizado con éxito!")
            mostrar_carrito(nuevo_carrito)
            menu(nuevo_carrito)

          {:error, msg} ->
            Util.mostrar_mensaje(msg)
            menu(carrito)
        end

      2 ->
        nombre = "Ingrese el nombre del producto a eliminar: " |> Util.ingresar(:texto)

        case eliminar_producto(carrito, nombre) do
          {:ok, nuevo_carrito} ->
            Util.mostrar_mensaje("¡Producto eliminado con éxito!")
            mostrar_carrito(nuevo_carrito)
            menu(nuevo_carrito)

          {:error, msg} ->
            Util.mostrar_mensaje(msg)
            menu(carrito)
        end

      3 ->
        mostrar_carrito(carrito)
        menu(carrito)

      4 ->
        Util.mostrar_mensaje("¡Gracias por usar el carrito de compras!")

      _ ->
        Util.mostrar_mensaje("Opción inválida, intente de nuevo.")
        menu(carrito)
    end
  end

  defp mostrar_carrito(carrito) do
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

  defp crear_producto(nombre, precio, cantidad) do
    %{
      nombre: nombre,
      precio: precio,
      cantidad: cantidad
    }
  end

  defp calcular_total(carrito) do
    Enum.reduce(carrito, 0, fn producto, total ->
      total + producto.precio * producto.cantidad
    end)
  end

  defp generar_mensaje(carrito, total) do
    mensajes =
      Enum.map(carrito, fn producto ->
        "Producto: #{producto.nombre} | " <>
          "Precio: #{producto.precio} | " <>
          "Cantidad: #{producto.cantidad}"
      end)

    mensajes ++ ["Total del carrito: #{total}"]
  end

  defp agregar_producto(carrito, producto) do
    [producto | carrito]
  end

  defp buscar_producto(carrito, nombre) do
    producto =
      Enum.find(carrito, fn producto ->
        producto.nombre == nombre
      end)

    if producto == nil do
      {:error, "Producto no encontrado"}
    else
      {:ok, producto}
    end
  end

  def actualizar_producto(carrito, nombre, nueva_cantidad) do
    resultado = buscar_producto(carrito, nombre)

    if resultado == {:error, "Producto no encontrado"} do
      resultado
    else
      nuevo_carrito =
        Enum.map(carrito, fn producto ->
          if producto.nombre == nombre do
            %{producto | cantidad: nueva_cantidad}
          else
            producto
          end
        end)

      {:ok, nuevo_carrito}
    end
  end

  def eliminar_producto(carrito, nombre) do
    resultado = buscar_producto(carrito, nombre)

    if resultado == {:error, "Producto no encontrado"} do
      resultado
    else
      nuevo_carrito =
        Enum.filter(carrito, fn producto ->
          producto.nombre != nombre
        end)

      {:ok, nuevo_carrito}
    end
  end
end
