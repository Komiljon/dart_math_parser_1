// Автор Камил
// Использую алгоритм "Обратная польская нотация" далее именуемой АОПН
// Помогла статья https://habr.com/ru/articles/282379/
// И еще https://ru.wikiversity.org/wiki/%D0%9E%D0%B1%D1%80%D0%B0%D1%82%D0%BD%D0%B0%D1%8F_%D0%BF%D0%BE%D0%BB%D1%8C%D1%81%D0%BA%D0%B0%D1%8F_%D0%B7%D0%B0%D0%BF%D0%B8%D1%81%D1%8C:_%D0%BF%D1%80%D0%B8%D0%BC%D0%B5%D1%80%D1%8B_%D1%80%D0%B5%D0%B0%D0%BB%D0%B8%D0%B7%D0%B0%D1%86%D0%B8%D0%B8#

// Поддерживаются константы с унарным минусом

// прверку на лищние элементы или запрещенные знаки Не делаю
// надеюсь, тестиировщик итак введет правильно))

// Ответ будет в Double так как пытался учесть и такие элементы в строке

class Calc {
  List outputlist = []; // лист. массив выхода
  List stack = []; //стэк. массив операции
  List specSymb = ['(', ')', '*', '/', '+', '-', '~']; // сымволы операций для проверки далее

  int x;
  Calc(this.x) {
    x = x;
  }

  // Создаем массив выхода
  void createOutString(String strInput) {
    strInput = strInput.toLowerCase();
    const String plus = '+';
    const String minus = '-';
    const String deliv = '/';
    const String multp = '*';
    const String unarMinus = '~';
    const String lscop = '(';
    const String rscop = ')';
    const String xVar = 'x';

    //List lsInput = strInput.split('');
    String stNum = '';
    List lsInput = [];
    // Создаем из строки лист lsInput где в роли разделителя будут знаки операций. Их тоже добавляем в лист т.е. массив
    for (int i = 0; i < strInput.length; i++) {
      if (specSymb.contains(strInput[i])) {
        if (stNum.isNotEmpty) {
          lsInput.add(stNum);
        }
        lsInput.add(strInput[i]);
        stNum = '';
      } else {
        stNum += strInput[i];
      }
    }
    if (stNum.isNotEmpty) {
      lsInput.add(stNum);
    }
    // Пробегаем по элементам lsInput и определяем добовление в стэк или массив выхода по правилам АОПН
    for (int i = 0; i < lsInput.length; i++) {
      switch (lsInput[i]) {
        case plus:
          addToStack(lsInput[i]);
        case minus:
          addToStack(lsInput[i]);
        case deliv:
          addToStack(lsInput[i]);
        case multp:
          addToStack(lsInput[i]);
        case unarMinus:
          addToStack(lsInput[i]);
        case lscop:
          addToStack(lsInput[i]);
        case rscop:
          addAllInScope(); // так как это ), мы должны вытолкнуть все из стека в массив выхода до ( и избавится от ( и )
        case xVar:
          addToOutput(x.toString());
        default:
          addToOutput(lsInput[i]);
      }
    }

    // выталкиваем все остатки из стека в массив выхода
    while (stack.isNotEmpty) {
      addToOutput(stack.last);
      stack.removeLast();
    }
  }

  // Определяем преоритет операции
  int operOrders(String op) {
    int order = 0;

    switch (op) {
      case '~':
        order = 4;
      case '/':
        order = 3;
      case '*':
        order = 3;
      case '+':
        order = 2;
      case '-':
        order = 2;
      case '(':
        order = 0;
      case ')':
        order = 0;
      default:
        order = 0;
    }
    return order;
  }

  // метод добавления в стэк лист
  addToStack(String st) {
    int newOrder = operOrders(st); // узнаем преоритет текущего элемента

    // помещаем в стэк или массив выхода по правилам приоритета АОПН
    if (stack.isNotEmpty) {
      int lastOrder = operOrders(stack.last); // узнаем преоритет предыдущего элемента
      if (lastOrder >= newOrder && newOrder > 0 && lastOrder > 0) {
        addToOutput(stack.last); // добавляем в массив выхода
        stack.removeLast(); // удаляем из стэк
      }
    }
    // повторяем шаг. Так надо))
    if (stack.isNotEmpty) {
      int lastOrder = operOrders(stack.last); // узнаем преоритет предыдущего элемента
      if (lastOrder >= newOrder && newOrder > 0 && lastOrder > 0) {
        addToOutput(stack.last); // добавляем в массив выхода
        stack.removeLast(); // удаляем из стэк
      }
    }

    stack.add(st); //добавляем в стэк

    //print("{$st === $stack}");
  }

  // метод добавления в массив выхода
  addToOutput(String st) {
    if (st != '(' && st != ')') {
      outputlist.add(st);
    }
  }

  // метод выталкивания все из стека в массив выхода до (
  addAllInScope() {
    if (stack.isNotEmpty) {
      for (int i = stack.length; i > 0; i--) {
        String elem = stack.last;
        if (elem != '(') {
          addToOutput(elem);
          stack.removeLast();
        } else {
          stack.removeLast();
          break;
        }
      }
    }
  }

  // Метод вычисляет результат из массива выхода по правилам АОПН
  double calculate() {
    double resDouble = 0;
    if (outputlist.isNotEmpty) {
      const String plus = '+';
      const String minus = '-';
      const String unarMinus = '~';
      const String deliv = '/';
      const String multp = '*';
      List resList = [];
      int listL = 0;

      for (int i = 0; i < outputlist.length; i++) {
        listL = resList.length;
        switch (outputlist[i]) {
          case plus:
            if (resList.isNotEmpty && resList.length >= 2) {
              resDouble = double.parse(resList[listL - 2].toString()) + double.parse(resList[listL - 1].toString());
              resList.removeLast();
              resList.removeLast();
              resList.add(resDouble);
            }
          case minus:
            if (resList.isNotEmpty && resList.length >= 2) {
              resDouble = double.parse(resList[listL - 2].toString()) - double.parse(resList[listL - 1].toString());
              resList.removeLast();
              resList.removeLast();
              resList.add(resDouble);
            }
          case unarMinus: //унарный минус
            if (resList.isNotEmpty) {
              resDouble = -1 * double.parse(resList[listL - 1].toString());
              resList.removeLast();
              resList.add(resDouble);
            }
          case deliv:
            if (resList.isNotEmpty && resList.length >= 2) {
              resDouble = double.parse(resList[listL - 2].toString()) / double.parse(resList[listL - 1].toString());
              resList.removeLast();
              resList.removeLast();
              resList.add(resDouble);
            }
          case multp:
            if (resList.isNotEmpty && resList.length >= 2) {
              resDouble = double.parse(resList[listL - 2].toString()) * double.parse(resList[listL - 1].toString());
              resList.removeLast();
              resList.removeLast();
              resList.add(resDouble);
            }
          default:
            resList.add(outputlist[i]);
          //print(resList);
        }
      }
    }
    return resDouble;
  }
}

void main() {
  //String varInput = '(6+10-4)/(1+1*2)+1'; //5.0
  //String varInput = '(6.5+10-4)/(1+1*2)+1'; //5.166666666666667

  //String varInput = '10*5+4/2-1'; //51.0
  //String varInput = '(x*3-5)/5'; //5.0
  //String varInput = '~3*x+15/(3+2)'; //-27.0 унарный минус

  String varInput = '3*x+15/(3+2)'; // 33.0
  int x = 10;
  Calc calcObj = Calc(x); // создаем обЪект класса Calc
  calcObj.createOutString(varInput); // собираем массив выхода
  //print(calcObj.outputlist);
  var resOut = calcObj.calculate(); // вызывем метод вычиисление
  print(resOut);
}
