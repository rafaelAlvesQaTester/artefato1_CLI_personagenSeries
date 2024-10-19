View().main()

class UserModel {
    var name: String = ""
    var favoriteCharacters: [CharacterModel] = []
}

class CharacterModel {
    var name: String
    
    init(_ name: String) {
        self.name = name
    }
}

enum Route {
    case home, options, characterList, addCharacters, characterSelect, deleteCharacterSelected, editCharacterSelected
}

class View {
    var viewModel: ViewModel = ViewModel()
    
    func main() {
        while true {
            switch viewModel.route {
                case .home:
                    homeView()
                case .options:
                    optionView()
                case .characterList:
                    characterListView()
                case .addCharacters:
                    addCharacterView()
                case .characterSelect:
                    characterSelectView()
                case .deleteCharacterSelected:
                    deleteCharacterView()
                case .editCharacterSelected:
                    editCharacterView()
            }
        }
    }
    
    func homeView() {
        print("Parta começar, informe seu nome: ")
        if !viewModel.setName() {
            print("Informe um nome válido: ")
        }
    }
    
    func optionView() {
        print("Seja bem vindo(a) \(viewModel.player.name)! O que você deseja fazer? ")
        print("A: Ver meus Personagens")
        print("B: Adicionar um novo Personagem")
        
        if !viewModel.setOptions() {
            print("Informe um valor válido: ")
        }
    }
    
    func characterListView() {
        if viewModel.player.favoriteCharacters.isEmpty {
            print("Você ainda não adicionou nenhum personagem.")
        } else {
            print("Os personagens adicionados foram:")
            for (index, character) in viewModel.player.favoriteCharacters.enumerated() {
                print("\(index + 1). \(character.name)")
            }
        }
        
        if viewModel.isCharacterSelected() {
            viewModel.route = .characterSelect
        } else {
            viewModel.route = .options
        }
    }
    
    func addCharacterView() {
        print("Nome do personagem:")
        
        if viewModel.setCharacter() {
            print("Personagem adicionado com sucesso!!!")
        } else {
            print("Coloque um nome válido!")
        }
    }
    
    func characterSelectView() {
        print("Escolha um personagem: ")
        
        if viewModel.selectCharacter() {
            if let character = viewModel.characterSelect {
                print("O que você deseja fazer com \(character.name)?")
                print("A - Editar ")
                print("B - Deletar ")
                print("C - Sair ")
                
                if !viewModel.selectOption() {
                    print("Faça uma seleção válida!")
                }
            }
        } else {
            print("Selecione uma opção válida")
        }
    }
    
    func editCharacterView() {
        guard let selectedCharacter = viewModel.characterSelect else { return }
        print("Digite o nome correto do personagem \(selectedCharacter.name):")
        
        if viewModel.editCharacterSelected() {
            print("Personagem editado com sucesso!")
        } else {
            print("Houve um erro ao atualizar o nome do personagem.")
        }
    }
    
    func deleteCharacterView() {
        print("Personagem deletado com sucesso!")
        viewModel.deleteCharacterSelected()
    }
}

class ViewModel {
    var route: Route = .home
    var player: UserModel = UserModel()
    var characterSelect: CharacterModel? // Character model or nil
    var characterSelectedIndex: Int?
    
    func setName() -> Bool {
        guard let value = readLine(), !value.isEmpty else {
            return false
        }
        
        player.name = value
        route = .options
        return true
    }
    
    func setOptions() -> Bool {
        guard let value = readLine() else {
            return false
        }
        
        let option = value.uppercased()
        
        if option == "A" {
            route = .characterList
        } else if option == "B" {
            route = .addCharacters
        } else {
            return false
        }
        
        return true
    }
    
    func selectCharacter() -> Bool {
        let value = readLine()
        
        guard let select = value else { return false }
        guard let index = Int(select) else { return false }
        
        if index > 0 && index <= player.favoriteCharacters.count {
            characterSelectedIndex = index - 1
            characterSelect = player.favoriteCharacters[characterSelectedIndex!]
            return true
        }
        return false
    }
    
    func setCharacter() -> Bool {
        guard let value = readLine(), !value.isEmpty else {
            return false
        }
        
        player.favoriteCharacters.append(CharacterModel(value))
        route = .options
        return true
    }
    
    func isCharacterSelected() -> Bool {
        print("Você deseja selecionar um personagem? (S/N)")
        guard let value = readLine() else {
            return false
        }
        
        return value.uppercased() == "S"
    }
    
    func selectOption() -> Bool {
        let value = readLine()
        
        guard let select = value else { return false }
        
        if select.uppercased() == "A" {
            route = .editCharacterSelected
            return true
        }
        if select.uppercased() == "B" {
            route = .deleteCharacterSelected
            return true
        }
        if select.uppercased() == "C" {
            route = .options
            return true
        }
        return false
    }
    
    func editCharacterSelected() -> Bool {
        guard let index = characterSelectedIndex else { return false }
        guard let newCharacter = readLine(), !newCharacter.isEmpty else { return false }
        
        player.favoriteCharacters[index].name = newCharacter
        route = .options
        return true
    }
    
    func deleteCharacterSelected() {
        guard let index = characterSelectedIndex else { return }
        player.favoriteCharacters.remove(at: index)
        route = .options
    }
}