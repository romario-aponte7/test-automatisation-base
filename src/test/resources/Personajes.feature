@REQ_BPONEBP-0001  @personajes @agente1
Feature: Manejo de API personajes ejemplos

  Background:
    * configure ssl = true

  @id:1 @ObtenerTodosLosPersonajes
  Scenario: Obtener lista de personajes y validar el primero
    Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/romario/api/characters'
    When method get
    Then status 200
    And match response == '#[1]'
    And match response[0].id == 1
    And match response[0].name == 'Iron Man'
    And match response[0].alterego == 'Tony Stark'
    And match response[0].description == 'Genius billionaire'
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
    And match response.description == 'Genius billionaire'
    And match response.powers contains 'Armor'
    And match response.powers contains 'Flight'
    And def schemaValidate = read('classpath:../data/personajes/DataSchemaPersonajes.json')
    And match response contains schemaValidate
