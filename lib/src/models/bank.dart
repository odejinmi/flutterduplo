class Bank {
  String? name;
  int? id;

  Bank(this.name, this.id);

  @override
  String toString() {
    return 'Bank{name: $name, id: $id}';
  }
}

class BankAccount {
  Bank? bank;
  String? number;
  String? name;

  BankAccount(this.bank, this.number, this.name);

  bool isValid() {
    if (number == null || name == null || number!.length < 10) {
      return false;
    }

    if (bank == null || bank!.id == null) {
      return false;
    }
    return true;
  }

  @override
  String toString() {
    return 'BankAccount{bank: $bank, number: $number, name: $name}';
  }
}
