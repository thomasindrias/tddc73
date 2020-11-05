import React from "react";
import {
  StyleSheet,
  View,
  SafeAreaView,
  Image,
  TouchableOpacity,
  Text,
  TextInput,
} from "react-native";

export default function App() {
  const [value, onChangeText] = React.useState("example@gmail.com");

  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.center}>
        <Image source={require("./assets/as_logo.png")} style={styles.image} />
      </View>

      <View style={styles.column}>
        <View style={styles.row}>
          <TouchableOpacity style={styles.button}>
            <Text>Button</Text>
          </TouchableOpacity>
          <TouchableOpacity style={styles.button}>
            <Text>Button</Text>
          </TouchableOpacity>
        </View>
        <View style={styles.row}>
          <TouchableOpacity style={styles.button}>
            <Text>Button</Text>
          </TouchableOpacity>
          <TouchableOpacity style={styles.button}>
            <Text>Button</Text>
          </TouchableOpacity>
        </View>
      </View>

      <View style={styles.row}>
        <Text style={{ marginVertical: 12 }}>Email</Text>
        <TextInput
          style={styles.txtInput}
          onChangeText={(text) => onChangeText(text)}
          value={value}
        />
      </View>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  button: {
    alignItems: "center",
    backgroundColor: "#DDDDDD",
    borderRadius: 5,
    fontWeight: "bold",
    height: 20,
    justifyContent: "center",
    padding: 20,
  },
  center: {
    alignItems: "center",
    flex: 1,
    justifyContent: "center",
  },
  column: {
    flex: 1,
    flexDirection: "column",
    marginVertical: 10,
  },
  container: {
    flex: 1,
    justifyContent: "center",
    marginHorizontal: 16,
  },
  image: {
    flex: 1,
    maxHeight: 180,
    minHeight: 120,
    resizeMode: "contain",
  },
  row: {
    flex: 1,
    flexDirection: "row",
    maxHeight: 80,
    justifyContent: "space-evenly",
  },
  txtInput: {
    borderBottomColor: "#40798c",
    borderBottomWidth: 3,
    height: 40,
    width: 200,
  },
});
