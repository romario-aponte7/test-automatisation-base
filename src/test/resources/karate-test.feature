@REQ_BPONEBP-0001  @personajes @agente1
Feature: Manejo de API personajes ejemplos

  Background:
    * configure ssl = true

  @id:1 @ObtenerTodosLosPersonajes
  Scenario: Obtener lista de personajes y validar el primero
    Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/romario/api/characters'
    When method get
    Then status 200
    And match response[0].id == 1
    And match response[0].name == 'Iron Man'
    And match response[0].alterego == 'Tony Stark'
    And match response[0].powers contains 'Armor'
    And match response[0].powers contains 'Flight'
    And def schemaValidate = read('classpath:../data/personajes/DataSchemaPersonajes.json')
    And match each response[*] contains schemaValidate

  @id:2 @ObtenerPersonajePorId
  Scenario: Obtener personaje por ID (exitoso)
    Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/romario/api/characters/1'
    When method get
    Then status 200
    And match response.id == 1
    And match response.name == 'Iron Man'
    And match response.alterego == 'Tony Stark'
    And match response.powers contains 'Armor'
    And match response.powers contains 'Flight'
    And def schemaValidate = read('classpath:../data/personajes/DataSchemaPersonajes.json')
    And match response contains schemaValidate

  @id:3 @ObtenerPersonajePorIdNoExiste
  Scenario: Obtener personaje por ID (no existe)
    Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/romario/api/characters/999'
    When method get
    Then status 404
    And match response == { error: '#string' }

  @id:4 @CrearPersonaje
  Scenario: Crear personaje (exitoso)
    * def uniqueName = 'Iron Man ' + java.util.UUID.randomUUID()
    Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/romario/api/characters'
    And request
      """
      {
        "name": "#(uniqueName)",
        "alterego": "Tony Stark",
        "description": "Genius billionaire",
        "powers": ["Armor", "Flight"]
      }
      """
    When method post
    Then status 201
    And match response.name == uniqueName
    And match response.alterego == "Tony Stark"
    And match response.description == "Genius billionaire"
    And match response.powers contains "Armor"
    And match response.powers contains "Flight"
    And def schemaValidate = read('classpath:../data/personajes/DataSchemaPersonajes.json')
    And match response contains schemaValidate

  @id:5 @CrearPersonajeDuplicado
  Scenario: Crear personaje (nombre duplicado)
    Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/romario/api/characters'
    And request
      """
      {
        "name": "Iron Man",
        "alterego": "Tony Stark",
        "description": "Genius billionaire",
        "powers": ["Armor", "Flight"]
      }
      """
    When method post
    Then status 400
    And match response == { error: "Character name already exists" }

  @id:6 @CrearPersonajeCamposRequeridos
  Scenario: Crear personaje (faltan campos requeridos)
    Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/romario/api/characters'
    And request
      """
      {
        "name": "",
        "alterego": "",
        "description": "",
        "powers": []
      }
      """
    When method post
    Then status 400
    And match response ==
      """
      {
        "name": "Name is required",
        "description": "Description is required",
        "powers": "Powers are required",
        "alterego": "Alterego is required"
      }
      """

  @id:7 @ActualizarPersonaje
  Scenario: Actualizar personaje (exitoso)
    Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/romario/api/characters/1'
    And request
      """
      {
        "name": "Iron Man",
        "alterego": "Tony Stark",
        "description": "Updated description",
        "powers": ["Armor", "Flight"]
      }
      """
    When method put
    Then status 200
    And match response.id == 1
    And match response.name == "Iron Man"
    And match response.alterego == "Tony Stark"
    And match response.description == "Updated description"
    And match response.powers contains "Armor"
    And match response.powers contains "Flight"
    And def schemaValidate = read('classpath:../data/personajes/DataSchemaPersonajes.json')
    And match response contains schemaValidate

  @id:8 @ActualizarPersonajeNoExiste
  Scenario: Actualizar personaje (no existe)
    Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/romario/api/characters/999'
    And request
      """
      {
        "name": "Iron Man",
        "alterego": "Tony Stark",
        "description": "Updated description",
        "powers": ["Armor", "Flight"]
      }
      """
    When method put
    Then status 404
    And match response == { "error": "Character not found" }

  @id:9 @EliminarPersonaje
  Scenario: Eliminar personaje (exitoso)
    Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/romario/api/characters'
    When method get
    Then status 200
    * def lastId = response[response.length - 1].id
    And url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/romario/api/characters/' + lastId
    And method delete
    And status 204

  @id:10 @EliminarPersonajeNoExiste
  Scenario: Eliminar personaje (no existe)
    Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/romario/api/characters/999'
    When method delete
    Then status 404
    And match response == read('classpath:../data/personajes/EliminarPersonajeNoExiste.json')
