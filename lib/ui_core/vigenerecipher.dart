class VigenereCipher {
  //	Encryption
  //	Encryption Logic: Using ASCII Dec Representation:
  //	Example:
  //	ASCII: "H" is 72 && "S" is 83
  //	((72-65) + (83-65)) % 26 + 65 >> Encrypted "Z"
  static String encrypt(String message, String key) {
    String eMessage = "";
    // message = message.toUpperCase();
    for (int i = 0, j = 0; i < message.length; i++) {
      int letter = message.codeUnitAt(i);
      eMessage += String.fromCharCode(
          letter + (key[i % key.length]).codeUnitAt(i) % 256);
      // eMessage += String.fromCharCode(
      //     (((letter - 65) + (key.codeUnitAt(j) - 65)) % 26 + 65));
      // j = ++j % key.length;
    }
    return eMessage;
  }

  //	Decryption
  //	Decryption Logic: Using ASCII Dec Representation:
  //	Example:
  //	ASCII: "Z" is 90 && "S" is 83
  //	(90-83+26) % 26 + 65 >> Encrypted "Z"
  static String decrypt(String message, String key) {
    String eMessage = "";
    // message = message.toUpperCase();
    for (int i = 0, j = 0; i < message.length; i++) {
      int letter = message.codeUnitAt(i);
      dynamic tmp = (letter - (key[i % key.length]).codeUnitAt(i) % 256);
      eMessage +=
          (tmp < 0) ? String.fromCharCode(255 + tmp) : String.fromCharCode(tmp);
      // eMessage +=
      //     String.fromCharCode(((letter - key.codeUnitAt(j) + 26) % 26 + 65));
      // j = ++j % key.length;
    }
    return eMessage;
  }
}
