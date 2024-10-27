// All this three lines bellow are importings
import path from "path";
import { fileURLToPath } from 'url';
import HtmlWebpackPlugin from "html-webpack-plugin";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

export default {
    mode: 'development',
    entry: './src/index.js',
    output: {
      path: path.resolve(__dirname, 'dist'),
      filename: './public/bundle.js',
    },
    experiments: {
        outputModule: true,
    },
    module: {
      rules: [
         { 
          test: /\.js$/, // apply to all JS files
          exclude: /node_modules/, // exclude all files on node_modules
          use: {
            loader: 'babel-loader',
          }
        }
      ]
    },
    plugins:[
        new HtmlWebpackPlugin({
            scriptLoading: "module",
            template: "public/index.html" // create a template to start from
        })
    ],
    devServer: {
        host: 'localhost', // where to run
        historyApiFallback: true,
        port: 3000, //given port to exec. app
        open: true,  // open new tab
        hot: true, // Enable webpack's Hot Module Replacement
        static: {
            directory: path.resolve(__dirname, "dist")
        }
    }
}
