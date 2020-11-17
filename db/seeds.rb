# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


Usuario.create( nombre: "Nombre", 
                apellido: "Apellido",
                dni: 9999,
                email: "admin@admin.com",
                fecha_nacimiento: Date.new(1960,10,30),
                password: "asdasd",
                rol: "admin")

Usuario.create( nombre: "Nombre", 
                apellido: "Apellido",
                dni: 9998,
                email: "chofer@chofer.com",
                fecha_nacimiento: Date.new(1960,10,30),
                password: "asdasd",
                rol: "chofer")

Usuario.create( nombre: "Nombre",
                apellido: "Apellido",
                dni: 9997,
                email: "cliente@cliente.com",
                fecha_nacimiento: Date.new(1960,10,30),
                password: "asdasd",
                rol: "cliente")