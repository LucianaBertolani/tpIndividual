type Producto = String

productoDeLujo :: Producto -> Bool
productoDeLujo nombreDelProducto = elem 'x' nombreDelProducto || elem 'z' nombreDelProducto

productoCodiciado :: Producto -> Bool
productoCodiciado = (>10).length -- length nombreDelProducto > 10

productoCorriente :: String -> Bool
productoCorriente nombreDelProducto = esVocal.head $ nombreDelProducto -- head nombreDelProducto == 'a' || head nombreDelProducto == 'e' || head nombreDelProducto == 'i' || head nombreDelProducto == 'o' || head nombreDelProducto == 'u'

esVocal :: Char -> Bool
esVocal letra = elem letra "AEIOUaeiou"

productoDeElite :: String -> Bool
productoDeElite nombreDelProducto = productoDeLujo nombreDelProducto && productoCodiciado nombreDelProducto && not (productoCorriente nombreDelProducto)

productoXL :: String -> String
productoXL nombreDelProducto = nombreDelProducto ++ "XL"

versionBarata :: String -> String
versionBarata nombreDelProducto = reverse nombreDelProducto

descodiciarProducto :: String -> String
descodiciarProducto = versionBarata.(take 10) -- take 10 nombreDelProducto

entregaSencilla :: String -> Bool
entregaSencilla fechaDiaMesAnio = even . length $ fechaDiaMesAnio

aplicarDescuento :: Fractional a => a -> a -> a
aplicarDescuento precio porcentajeDescuento = precio - precio * porcentajeDescuento/100
-- aplicarDescuento :: Num a => a -> a -> a
-- aplicarDescuento precio porcentajeDescuento = precio - precio * porcentajeDescuento * 0.01

aplicarCostoDeEnvio :: Num a => a -> a -> a
aplicarCostoDeEnvio precio costoDeEnvio = precio + costoDeEnvio

--precioTotal :: Num a => a -> a -> int -> a -> a
--precioTotal precioUnitario descuento numero costoDeEnvio = numero * aplicarCostoDeEnvio (aplicarDescuento precioUnitario descuento) costoDeEnvio