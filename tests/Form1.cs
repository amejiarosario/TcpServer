using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using ClientSockets.Synchronous.UsingByteArray;
namespace FT_Client
{
    public partial class Form1 : Form
    {
        SynchronusClient_ByteArr objClient = new SynchronusClient_ByteArr("","localhost",@"C:\Documents and Settings\Administrator\UserData");
        
        public Form1()
        {
            
            InitializeComponent();
            objClient.FileSendCompleted += new SynchronusClient_ByteArr.FileSendCompletedDelegate(objClient_FileSendCompleted);
            objClient.FileReceiveCompleted += new SynchronusClient_ByteArr.FileSendCompletedDelegate(objClient_FileReceiveCompleted);
        }

        void objClient_FileReceiveCompleted()
        {
            MessageBox.Show("File receive done");
        }

        void objClient_FileSendCompleted()
        {
            MessageBox.Show("File send done!!!");
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            
        }

        private void btnSend_Click(object sender, EventArgs e)
        {
            objClient.SendFileToServer("", "");
        }

        private void btnReceive_Click(object sender, EventArgs e)
        {
            
            objClient.ReceiveFileFromServer(txtFileName.Text);

        }
        
    }
}