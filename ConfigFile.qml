/**
  * @author Jozef Mlich <xmlich02@stdu.fit.vutbr.cz>
  * @licence LGPL
  */

// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 2.0
import QtQuick.LocalStorage 2.0

Item {

    property string dbName: "twitterWall"
    property string dbVersion: "1.0"
    property string dbDisplayName: "twitterWall"
    property int dbEstimatedSize: 100

    function set(key, value) {
        var db = LocalStorage.openDatabaseSync(dbName, dbVersion, dbDisplayName, dbEstimatedSize);
        db.transaction(
                    function(tx) {
                        tx.executeSql('CREATE TABLE IF NOT EXISTS Keys(key TEXT, value TEXT)');
                        var rs = tx.executeSql('SELECT * FROM Keys WHERE key==?', [ key ]);

                        if (rs.rows.length === 0){
                            tx.executeSql('INSERT INTO Keys VALUES(?, ?)', [ key, value ]);
                        } else {
                            tx.executeSql('UPDATE Keys SET value=? WHERE key==?', [value, key]);
                        }
                    })
    }

    function get(key) {
        var db = LocalStorage.openDatabaseSync(dbName, dbVersion, dbDisplayName, dbEstimatedSize);
        var result = "";
        db.transaction(
                    function(tx) {

                        tx.executeSql('CREATE TABLE IF NOT EXISTS Keys(key TEXT, value TEXT)');
                        var rs = tx.executeSql('SELECT * FROM Keys WHERE key=?', [ key ]);
                        if (rs.rows.length === 1 && rs.rows.item(0).value.length > 0){
                            result = rs.rows.item(0).value
                        }
                        else {
                            result = "";
                            console.log("get("+key+"): not found")
                        }
                    }
                    )
        return result;
    }

}
