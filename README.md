# Parking Control - Controle de Estacionamento

## Português

### Sobre o Projeto

Este aplicativo foi desenvolvido como solução para o teste técnico da Raro Labs, com o objetivo de resolver o problema do Sr. João, proprietário de um estacionamento que atualmente gerencia suas operações manualmente em um caderno.

O Sr. João precisava de uma solução mobile que permitisse:
- Visualizar quais vagas estão ocupadas ou disponíveis
- Registrar entradas e saídas de veículos
- Associar veículos às vagas específicas
- Manter um histórico de movimentações para fechamento diário
- Interface simples e intuitiva, considerando que o usuário não é familiarizado com tecnologias complexas

### Tecnologias Utilizadas

- **Flutter**: Framework para desenvolvimento multiplataforma
- **Provider**: Gerenciamento de estado
- **SQLite (sqflite)**: Banco de dados local para persistência
- **PDF & Printing**: Geração de relatórios em PDF
- **Mockito & Flutter Test**: Frameworks para testes unitários e de widgets
- **Google Fonts**: Tipografia consistente
- **UUID**: Geração de identificadores únicos
- **Intl**: Formatação de datas e números

### Arquitetura e Padrões

O projeto segue uma arquitetura MVVM (Model-View-ViewModel) com os seguintes componentes:

- **Models**: Representações dos dados (Vehicle, ParkingSpot)
- **ViewModels**: Lógica de negócio e gerenciamento de estado (ParkingViewModel)
- **Services**: Serviços para operações específicas (DatabaseService, PDFService)
- **Widgets**: Componentes reutilizáveis da interface
- **Screens**: Telas do aplicativo

Princípios aplicados:
- **SOLID**: Princípios de design orientado a objetos
- **DRY (Don't Repeat Yourself)**: Evitando duplicação de código
- **Clean Code**: Código legível e bem estruturado
- **Testes Abrangentes**: Testes unitários e de widgets para garantir qualidade

### Estrutura do Projeto

```
lib/
├── main.dart              # Ponto de entrada do aplicativo
├── models/               # Modelos de dados
│   ├── parking_spot.dart  # Modelo para vagas de estacionamento
│   └── vehicle.dart       # Modelo para veículos
├── screens/              # Telas do aplicativo
│   └── home_screen.dart   # Tela principal
├── services/             # Serviços
│   ├── database_service.dart  # Serviço de banco de dados
│   └── pdf_service.dart      # Serviço para geração de PDF
├── themes/               # Temas e estilos
│   └── app_themes.dart    # Definições de tema claro e escuro
├── viewmodels/           # ViewModels
│   └── parking_viewmodel.dart  # ViewModel principal
└── widgets/              # Widgets reutilizáveis
    ├── clear_records_dialog.dart    # Diálogo para limpar registros
    ├── parking_spot_tile.dart       # Tile para exibir vagas
    ├── vehicle_entry_dialog.dart    # Diálogo para entrada de veículos
    ├── vehicle_exit_dialog.dart     # Diálogo para saída de veículos
    └── vehicle_history_dialog.dart  # Diálogo para histórico
```

### Funcionalidades

1. **Visualização de Vagas**: Interface grid que mostra o status de cada vaga (ocupada/livre)
2. **Registro de Entrada**: Formulário para registrar novos veículos com placa, descrição e motorista
3. **Registro de Saída**: Processo para registrar a saída de veículos
4. **Histórico**: Visualização do histórico de entradas e saídas
5. **Relatórios**: Geração de relatórios em PDF
6. **Tema Claro/Escuro**: Suporte a tema claro e escuro seguindo as configurações do sistema

### Como Executar o Projeto

1. **Pré-requisitos**:
   - Flutter SDK instalado (versão 3.7.0 ou superior)
   - Dart SDK instalado
   - Editor de código (VS Code, Android Studio, etc)

2. **Configuração**:
   ```bash
   # Clone o repositório
   git clone [url-do-repositorio]
   
   # Navegue até o diretório do projeto
   cd parking_control
   
   # Instale as dependências
   flutter pub get
   ```

3. **Execução**:
   ```bash
   # Execute o aplicativo no dispositivo/emulador conectado
   flutter run
   ```

4. **Testes**:
   ```bash
   # Execute os testes unitários e de widgets
   flutter test
   ```

## English

### About the Project

This application was developed as a solution for the Raro Labs technical test, aiming to solve the problem of Mr. João, a parking lot owner who currently manages his operations manually in a notebook.

Mr. João needed a mobile solution that would allow him to:
- View which parking spots are occupied or available
- Register vehicle entries and exits
- Associate vehicles with specific parking spots
- Maintain a history of movements for daily closing
- Simple and intuitive interface, considering that the user is not familiar with complex technologies

### Technologies Used

- **Flutter**: Framework for cross-platform development
- **Provider**: State management
- **SQLite (sqflite)**: Local database for persistence
- **PDF & Printing**: PDF report generation
- **Mockito & Flutter Test**: Frameworks for unit and widget testing
- **Google Fonts**: Consistent typography
- **UUID**: Generation of unique identifiers
- **Intl**: Date and number formatting

### Architecture and Patterns

The project follows an MVVM (Model-View-ViewModel) architecture with the following components:

- **Models**: Data representations (Vehicle, ParkingSpot)
- **ViewModels**: Business logic and state management (ParkingViewModel)
- **Services**: Services for specific operations (DatabaseService, PDFService)
- **Widgets**: Reusable interface components
- **Screens**: Application screens

Applied principles:
- **SOLID**: Object-oriented design principles
- **DRY (Don't Repeat Yourself)**: Avoiding code duplication
- **Clean Code**: Readable and well-structured code
- **Comprehensive Testing**: Unit and widget tests to ensure quality

### Project Structure

```
lib/
├── main.dart              # Application entry point
├── models/               # Data models
│   ├── parking_spot.dart  # Parking spot model
│   └── vehicle.dart       # Vehicle model
├── screens/              # Application screens
│   └── home_screen.dart   # Main screen
├── services/             # Services
│   ├── database_service.dart  # Database service
│   └── pdf_service.dart      # PDF generation service
├── themes/               # Themes and styles
│   └── app_themes.dart    # Light and dark theme definitions
├── viewmodels/           # ViewModels
│   └── parking_viewmodel.dart  # Main ViewModel
└── widgets/              # Reusable widgets
    ├── clear_records_dialog.dart    # Dialog for clearing records
    ├── parking_spot_tile.dart       # Tile for displaying spots
    ├── vehicle_entry_dialog.dart    # Dialog for vehicle entry
    ├── vehicle_exit_dialog.dart     # Dialog for vehicle exit
    └── vehicle_history_dialog.dart  # Dialog for history
```

### Features

1. **Parking Spot Visualization**: Grid interface showing the status of each spot (occupied/free)
2. **Entry Registration**: Form to register new vehicles with plate, description, and driver
3. **Exit Registration**: Process to register vehicle exits
4. **History**: View of entry and exit history
5. **Reports**: PDF report generation
6. **Light/Dark Theme**: Support for light and dark themes following system settings

### How to Run the Project

1. **Prerequisites**:
   - Flutter SDK installed (version 3.7.0 or higher)
   - Dart SDK installed
   - Code editor (VS Code, Android Studio, etc)

2. **Setup**:
   ```bash
   # Clone the repository
   git clone [repository-url]
   
   # Navigate to the project directory
   cd parking_control
   
   # Install dependencies
   flutter pub get
   ```

3. **Execution**:
   ```bash
   # Run the app on the connected device/emulator
   flutter run
   ```

4. **Tests**:
   ```bash
   # Run unit and widget tests
   flutter test
   ```

### Raro Labs Test

This project was developed as a solution for the Raro Labs technical test, which required creating a mobile application for a parking lot owner. The test evaluated:

1. Good architecture choice
2. Clean code and programming best practices (SOLID, DRY)
3. Unit and widget tests
4. Simple solution implementation
5. Simple interface that solves the problem

The solution implemented addresses all these requirements through a clean MVVM architecture, comprehensive test coverage, and a simple yet effective user interface that allows Mr. João to manage his parking lot operations efficiently from his smartphone.
