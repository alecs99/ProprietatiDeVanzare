pragma solidity ^0.5.0;

contract ProprietateContract {

  address public proprietar;
  uint public nrProprietati = 0;
  
  constructor() public {
    proprietar = msg.sender;
  }
  
  mapping(uint => Proprietate) public proprietati;

  struct Proprietate {
    uint idProprietate;
    string locatie;
    uint pret;
    address payable proprietar;
    bool deVanzare;
  }

  event Adauga(
    uint idProprietate, 
    string locatie, 
    uint pret, 
    address payable proprietar, 
    bool deVanzare
  );

  event Transfer(
    uint idProprietate, 
    string locatie, 
    uint pret, 
    address payable proprietar, 
    bool deVanzare
  );

  event Listeaza(
    uint idProprietate, 
    string locatie, 
    uint pret, 
    address payable proprietar, 
    bool deVanzare
  );
    

  function adaugaProprietate(string memory locatie, uint pret) public {
    require(msg.sender == proprietar);
    require(bytes(locatie).length > 0, 'Campul locatie este obligatoriu');
    require(pret > 0, 'Pretul trebuie sa fie mai mare ca 0');
    nrProprietati++;
    proprietati[nrProprietati] = Proprietate(nrProprietati, locatie, pret, msg.sender, true);
    emit Adauga(nrProprietati, locatie, pret, msg.sender, true);
  }

  function cumparaProprietate(uint id) public payable {
    Proprietate memory proprietate = proprietati[id];
    address payable detinatorProprietate = proprietate.proprietar;
    require(proprietate.idProprietate > 0 && proprietate.idProprietate <= nrProprietati, 'Proprietatea nu exista');
    require(proprietate.deVanzare == true, 'Proprietatea nu este de vanzare');
    require(msg.value >= proprietate.pret, 'Fonduri insuficiente');
    require(detinatorProprietate != msg.sender, 'Nu poti cumpara o proprietate deja detinuta');
    proprietate.proprietar = msg.sender;
    proprietate.deVanzare = false;
    address(detinatorProprietate).transfer(msg.value);
    emit Transfer(nrProprietati, proprietate.locatie, proprietate.pret, msg.sender, false);
  }
  
  
  function listareProprietate(uint id, uint pret) public payable {
    Proprietate memory proprietate = proprietati[id];
    require(proprietate.idProprietate > 0 && proprietate.idProprietate <= nrProprietati, 'Proprietatea nu exista');
    require(proprietate.proprietar == msg.sender, 'Nu esti proprietarul acestei proprietati');
    require(proprietate.deVanzare == false, 'Proprietatea este deja listata');
    proprietate.deVanzare = true;
    proprietate.pret = pret;
    proprietati[id] = proprietate;
    emit Adauga(id, proprietate.locatie, pret, msg.sender, true);
  }
}