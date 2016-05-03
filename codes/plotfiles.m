clc;clear all;close all;
bitrate=.1:.1:1;
outfolder='figure/';
%%
csv_C_A_d=csvread('analysis/C_Aware_diff.csv') ;
csv_C_A_s=csvread('analysis/C_Aware_same.csv') ;
csv_C_O_d=csvread('analysis/C_over_diff.csv') ;
csv_C_O_s=csvread('analysis/C_over_same.csv') ;
f1=figure('Units','inches','Position',[0 0 5 4],'PaperPositionMode','auto');
packet_length=csv_C_A_d(:,1);
speed_C_A_d=csv_C_A_d(:,3);
speed_C_A_s=csv_C_A_s(:,3);
speed_C_O_d=csv_C_O_d(:,3);
speed_C_O_s=csv_C_O_s(:,3);

plot(packet_length,speed_C_A_s,'-db',packet_length,speed_C_O_s,'-dr','linewidth',1.5)
h1=legend('CUDA-Aware MPI','CUDA Over MPI','Location','northwest');set(h1,'Interpreter','latex');
 title('CUDA Over MPI vs CUDA-Aware MPI : Same node','interpreter','latex');
 xlabel('Data Transferred (in Bytes)','interpreter','latex');
 ylabel('Bandwidth (in MBps)','interpreter','latex');
xlim([0 max(packet_length)])
set(gca,'Units','normalized','FontUnits','points','FontWeight','normal','FontSize',9,'FontName','Times','TickLabelInterpreter', 'latex')
D = f1.PaperPosition;
set(gcf, 'PaperPositionMode','auto')
f1.PaperSize = [D(3) D(4)];
print(f1,'-dpdf',strcat(outfolder,'C_Same'),'-r0');

f2=figure('Units','inches','Position',[0 0 5 4],'PaperPositionMode','auto');
plot(packet_length,speed_C_A_d,'-db',packet_length,speed_C_O_d,'-dr','linewidth',1.5)


h1=legend('CUDA-Aware MPI','CUDA Over MPI','Location','southeast');set(h1,'Interpreter','latex');

set(h1,'Interpreter','latex');
 title('CUDA Over MPI vs CUDA-Aware MPI : Different nodes','interpreter','latex');
 xlabel('Data Transferred (in Bytes)','interpreter','latex');
 ylabel('Bandwidth (in MBps)','interpreter','latex');
xlim([0 max(packet_length)])
set(gca,'Units','normalized','FontUnits','points','FontWeight','normal','FontSize',9,'FontName','Times','TickLabelInterpreter', 'latex')
D = f2.PaperPosition;
set(gcf, 'PaperPositionMode','auto')
f2.PaperSize = [D(3) D(4)];
print(f2,'-dpdf',strcat(outfolder,'C_Diff'),'-r0');

% Plot 8
full=readf('analysis/full_8.csv',3) ;
bcastB=readf('analysis/bcast_8.csv',2) ;
sendA=readf('analysis/sendA_8.csv',2) ;
sendC=readf('analysis/sendC_8.csv',2) ;
recvA=readf('analysis/recvA_8.csv',2) ;
recvC=readf('analysis/recvC_8.csv',2) ;
xl=[2000,4000,6000,8000,10000];
types=full{1};full_N=full{2};full_time=full{3};
[unq,temind] = unique(types);u=types(sort(temind));yl=zeros(6,length(xl));
for i=1:length(temind)
    yl(i,:)=full_time(temind(i):temind(i)+length(xl)-1);
end

f2=figure('Units','inches','Position',[0 0 5 4],'PaperPositionMode','auto');
plot(xl,yl(1,:),'-db',xl,yl(2,:),'-dr',xl,yl(3,:),'-dg',xl,yl(4,:),'--b',xl,yl(5,:),'--r',xl,yl(6,:),'--g','linewidth',1.5)
h1=legend('MVAPICH2-Ethernet','MVAPICH2-OpenIB','MVAPICH2-Same node','OpenMPI-Ethernet','OpenMPI-OpenIB','OpenMPI-Same node','Location','northwest');set(h1,'Interpreter','latex');

set(h1,'Interpreter','latex');
 title('Total Time: 8 Processes','interpreter','latex');
 xlabel('Matrix Size N','interpreter','latex');
 ylabel('Time (in seconds)','interpreter','latex');
set(gca,'Units','normalized','FontUnits','points','FontWeight','normal','FontSize',9,'FontName','Times','TickLabelInterpreter', 'latex')
D = f2.PaperPosition;
set(gcf, 'PaperPositionMode','auto')
f2.PaperSize = [D(3) D(4)];
print(f2,'-dpdf',strcat(outfolder,'full_8'),'-r0');

f2=figure('Units','inches','Position',[0 0 5 4],'PaperPositionMode','auto');

xl=[2000,4000,6000,8000,10000];
types=bcastB{1};full_time=bcastB{2};

[unq,temind] = unique(types);u=types(sort(temind));yl=zeros(6,length(xl));
for i=1:length(temind)
    yl(i,:)=full_time(temind(i):temind(i)+length(xl)-1);
end
plot(xl,yl(1,:),'-db',xl,yl(2,:),'-dr',xl,yl(3,:),'-dg',xl,yl(4,:),'--b',xl,yl(5,:),'--r',xl,yl(6,:),'--g','linewidth',1.5)
h1=legend('MVAPICH2-Ethernet','MVAPICH2-OpenIB','MVAPICH2-Same node','OpenMPI-Ethernet','OpenMPI-OpenIB','OpenMPI-Same node','Location','northwest');set(h1,'Interpreter','latex');

set(h1,'Interpreter','latex');
 title('Broadcast Time B Matrix: 8 Processes','interpreter','latex');
 xlabel('Matrix Size N','interpreter','latex');
 ylabel('Time (in seconds)','interpreter','latex');
set(gca,'Units','normalized','FontUnits','points','FontWeight','normal','FontSize',9,'FontName','Times','TickLabelInterpreter', 'latex')
D = f2.PaperPosition;
set(gcf, 'PaperPositionMode','auto')
f2.PaperSize = [D(3) D(4)];
print(f2,'-dpdf',strcat(outfolder,'bcast_8'),'-r0');

f2=figure('Units','inches','Position',[0 0 5 4],'PaperPositionMode','auto');

xl=[2000,4000,6000,8000,10000];
types=sendA{1};full_time=recvA{2}-sendA{2};

[unq,temind] = unique(types);u=types(sort(temind));yl=zeros(6,length(xl));

for i=1:length(temind)
    yl(i,:)=full_time(temind(i):temind(i)+length(xl)-1);
end
plot(xl,yl(1,:),'-db',xl,yl(2,:),'-dr',xl,yl(3,:),'-dg',xl,yl(4,:),'--b',xl,yl(5,:),'--r',xl,yl(6,:),'--g','linewidth',1.5)
h1=legend('MVAPICH2-Ethernet','MVAPICH2-OpenIB','MVAPICH2-Same node','OpenMPI-Ethernet','OpenMPI-OpenIB','OpenMPI-Same node','Location','northwest');set(h1,'Interpreter','latex');

set(h1,'Interpreter','latex');
 title('Send Receive A Matrix: 8 Processes','interpreter','latex');
 xlabel('Matrix Size N','interpreter','latex');
 ylabel('Time (in seconds)','interpreter','latex');
set(gca,'Units','normalized','FontUnits','points','FontWeight','normal','FontSize',9,'FontName','Times','TickLabelInterpreter', 'latex')
D = f2.PaperPosition;
set(gcf, 'PaperPositionMode','auto')
f2.PaperSize = [D(3) D(4)];
print(f2,'-dpdf',strcat(outfolder,'sendrecvA_8'),'-r0');

f2=figure('Units','inches','Position',[0 0 5 4],'PaperPositionMode','auto');

xl=[2000,4000,6000,8000,10000];
types=sendC{1};full_time=recvC{2}-sendC{2};

[unq,temind] = unique(types);u=types(sort(temind));yl=zeros(6,length(xl));

for i=1:length(temind)
    yl(i,:)=full_time(temind(i):temind(i)+length(xl)-1);
end
plot(xl,yl(1,:),'-db',xl,yl(2,:),'-dr',xl,yl(3,:),'-dg',xl,yl(4,:),'--b',xl,yl(5,:),'--r',xl,yl(6,:),'--g','linewidth',1.5)
h1=legend('MVAPICH2-Ethernet','MVAPICH2-OpenIB','MVAPICH2-Same node','OpenMPI-Ethernet','OpenMPI-OpenIB','OpenMPI-Same node','Location','northwest');set(h1,'Interpreter','latex');

set(h1,'Interpreter','latex');
 title('Send Receive C Matrix: 8 Processes','interpreter','latex');
 xlabel('Matrix Size N','interpreter','latex');
 ylabel('Time (in seconds)','interpreter','latex');
set(gca,'Units','normalized','FontUnits','points','FontWeight','normal','FontSize',9,'FontName','Times','TickLabelInterpreter', 'latex')
D = f2.PaperPosition;
set(gcf, 'PaperPositionMode','auto')
f2.PaperSize = [D(3) D(4)];
print(f2,'-dpdf',strcat(outfolder,'sendrecvC_8'),'-r0');

%% Plot 16
full=readf('analysis/full_16.csv',3) ;
bcastB=readf('analysis/bcast_16.csv',2) ;
sendA=readf('analysis/sendA_16.csv',2) ;
sendC=readf('analysis/sendC_16.csv',2) ;
recvA=readf('analysis/recvA_16.csv',2) ;
recvC=readf('analysis/recvC_16.csv',2) ;
xl=[2000,4000,6000,8000,10000];
types=full{1};full_N=full{2};full_time=full{3};
[unq,temind] = unique(types);u=types(sort(temind));yl=zeros(6,length(xl));
for i=1:length(temind)
    yl(i,:)=full_time(temind(i):temind(i)+length(xl)-1);
end

f2=figure('Units','inches','Position',[0 0 5 4],'PaperPositionMode','auto');
plot(xl,yl(1,:),'-db',xl,yl(2,:),'-dr',xl,yl(3,:),'-dg',xl,yl(4,:),'--b',xl,yl(5,:),'--r',xl,yl(6,:),'--g','linewidth',1.5)
h1=legend('MVAPICH2-Ethernet','MVAPICH2-OpenIB','MVAPICH2-Same node','OpenMPI-Ethernet','OpenMPI-OpenIB','OpenMPI-Same node','Location','northwest');set(h1,'Interpreter','latex');

set(h1,'Interpreter','latex');
 title('Total Time: 16 Processes','interpreter','latex');
 xlabel('Matrix Size N','interpreter','latex');
 ylabel('Time (in seconds)','interpreter','latex');
set(gca,'Units','normalized','FontUnits','points','FontWeight','normal','FontSize',9,'FontName','Times','TickLabelInterpreter', 'latex')
D = f2.PaperPosition;
set(gcf, 'PaperPositionMode','auto')
f2.PaperSize = [D(3) D(4)];
print(f2,'-dpdf',strcat(outfolder,'full_16'),'-r0');

f2=figure('Units','inches','Position',[0 0 5 4],'PaperPositionMode','auto');

xl=[2000,4000,6000,8000,10000];
types=bcastB{1};full_time=bcastB{2};

[unq,temind] = unique(types);u=types(sort(temind));yl=zeros(6,length(xl));
for i=1:length(temind)
    yl(i,:)=full_time(temind(i):temind(i)+length(xl)-1);
end
plot(xl,yl(1,:),'-db',xl,yl(2,:),'-dr',xl,yl(3,:),'-dg',xl,yl(4,:),'--b',xl,yl(5,:),'--r',xl,yl(6,:),'--g','linewidth',1.5)
h1=legend('MVAPICH2-Ethernet','MVAPICH2-OpenIB','MVAPICH2-Same node','OpenMPI-Ethernet','OpenMPI-OpenIB','OpenMPI-Same node','Location','northwest');set(h1,'Interpreter','latex');

set(h1,'Interpreter','latex');
 title('Broadcast Time B Matrix: 16 Processes','interpreter','latex');
 xlabel('Matrix Size N','interpreter','latex');
 ylabel('Time (in seconds)','interpreter','latex');
set(gca,'Units','normalized','FontUnits','points','FontWeight','normal','FontSize',9,'FontName','Times','TickLabelInterpreter', 'latex')
D = f2.PaperPosition;
set(gcf, 'PaperPositionMode','auto')
f2.PaperSize = [D(3) D(4)];
print(f2,'-dpdf',strcat(outfolder,'bcast_16'),'-r0');

f2=figure('Units','inches','Position',[0 0 5 4],'PaperPositionMode','auto');

xl=[2000,4000,6000,8000,10000];
types=sendA{1};full_time=recvA{2}-sendA{2};

[unq,temind] = unique(types);u=types(sort(temind));yl=zeros(6,length(xl));

for i=1:length(temind)
    yl(i,:)=full_time(temind(i):temind(i)+length(xl)-1);
end
plot(xl,yl(1,:),'-db',xl,yl(2,:),'-dr',xl,yl(3,:),'-dg',xl,yl(4,:),'--b',xl,yl(5,:),'--r',xl,yl(6,:),'--g','linewidth',1.5)
h1=legend('MVAPICH2-Ethernet','MVAPICH2-OpenIB','MVAPICH2-Same node','OpenMPI-Ethernet','OpenMPI-OpenIB','OpenMPI-Same node','Location','northwest');set(h1,'Interpreter','latex');

set(h1,'Interpreter','latex');
 title('Send Receive A Matrix: 16 Processes','interpreter','latex');
 xlabel('Matrix Size N','interpreter','latex');
 ylabel('Time (in seconds)','interpreter','latex');
set(gca,'Units','normalized','FontUnits','points','FontWeight','normal','FontSize',9,'FontName','Times','TickLabelInterpreter', 'latex')
D = f2.PaperPosition;
set(gcf, 'PaperPositionMode','auto')
f2.PaperSize = [D(3) D(4)];
print(f2,'-dpdf',strcat(outfolder,'sendrecvA_16'),'-r0');

f2=figure('Units','inches','Position',[0 0 5 4],'PaperPositionMode','auto');

xl=[2000,4000,6000,8000,10000];
types=sendC{1};full_time=recvC{2}-sendC{2};

[unq,temind] = unique(types);u=types(sort(temind));yl=zeros(6,length(xl));

for i=1:length(temind)
    yl(i,:)=full_time(temind(i):temind(i)+length(xl)-1);
end
plot(xl,yl(1,:),'-db',xl,yl(2,:),'-dr',xl,yl(3,:),'-dg',xl,yl(4,:),'--b',xl,yl(5,:),'--r',xl,yl(6,:),'--g','linewidth',1.5)
h1=legend('MVAPICH2-Ethernet','MVAPICH2-OpenIB','MVAPICH2-Same node','OpenMPI-Ethernet','OpenMPI-OpenIB','OpenMPI-Same node','Location','northwest');set(h1,'Interpreter','latex');

set(h1,'Interpreter','latex');
 title('Send Receive C Matrix: 16 Processes','interpreter','latex');
 xlabel('Matrix Size N','interpreter','latex');
 ylabel('Time (in seconds)','interpreter','latex');
set(gca,'Units','normalized','FontUnits','points','FontWeight','normal','FontSize',9,'FontName','Times','TickLabelInterpreter', 'latex')
D = f2.PaperPosition;
set(gcf, 'PaperPositionMode','auto')
f2.PaperSize = [D(3) D(4)];
print(f2,'-dpdf',strcat(outfolder,'sendrecvC_16'),'-r0');

%% Plot 32
full=readf('analysis/full_32.csv',3) ;
bcastB=readf('analysis/bcast_32.csv',2) ;
sendA=readf('analysis/sendA_32.csv',2) ;
sendC=readf('analysis/sendC_32.csv',2) ;
recvA=readf('analysis/recvA_32.csv',2) ;
recvC=readf('analysis/recvC_32.csv',2) ;
xl=[2000,4000,6000,8000,10000];
types=full{1};full_N=full{2};full_time=full{3};
[unq,temind] = unique(types);u=types(sort(temind));yl=zeros(4,length(xl));
for i=1:length(temind)
    yl(i,:)=full_time(temind(i):temind(i)+length(xl)-1);
end

f2=figure('Units','inches','Position',[0 0 5 4],'PaperPositionMode','auto');
plot(xl,yl(1,:),'-db',xl,yl(2,:),'-dr',xl,yl(3,:),'--b',xl,yl(4,:),'--r','linewidth',1.5)
h1=legend('MVAPICH2-Ethernet','MVAPICH2-OpenIB','OpenMPI-Ethernet','OpenMPI-OpenIB','Location','northwest');set(h1,'Interpreter','latex');

set(h1,'Interpreter','latex');
 title('Total Time: 32 Processes','interpreter','latex');
 xlabel('Matrix Size N','interpreter','latex');
 ylabel('Time (in seconds)','interpreter','latex');
set(gca,'Units','normalized','FontUnits','points','FontWeight','normal','FontSize',9,'FontName','Times','TickLabelInterpreter', 'latex')
D = f2.PaperPosition;
set(gcf, 'PaperPositionMode','auto')
f2.PaperSize = [D(3) D(4)];
print(f2,'-dpdf',strcat(outfolder,'full_32'),'-r0');

f2=figure('Units','inches','Position',[0 0 5 4],'PaperPositionMode','auto');

xl=[2000,4000,6000,8000,10000];
types=bcastB{1};full_time=bcastB{2};

[unq,temind] = unique(types);u=types(sort(temind));yl=zeros(6,length(xl));
for i=1:length(temind)
    yl(i,:)=full_time(temind(i):temind(i)+length(xl)-1);
end
plot(xl,yl(1,:),'-db',xl,yl(2,:),'-dr',xl,yl(3,:),'--b',xl,yl(4,:),'--r','linewidth',1.5)
h1=legend('MVAPICH2-Ethernet','MVAPICH2-OpenIB','OpenMPI-Ethernet','OpenMPI-OpenIB','Location','northwest');set(h1,'Interpreter','latex');

set(h1,'Interpreter','latex');
 title('Broadcast Time B Matrix: 32 Processes','interpreter','latex');
 xlabel('Matrix Size N','interpreter','latex');
 ylabel('Time (in seconds)','interpreter','latex');
set(gca,'Units','normalized','FontUnits','points','FontWeight','normal','FontSize',9,'FontName','Times','TickLabelInterpreter', 'latex')
D = f2.PaperPosition;
set(gcf, 'PaperPositionMode','auto')
f2.PaperSize = [D(3) D(4)];
print(f2,'-dpdf',strcat(outfolder,'bcast_32'),'-r0');

f2=figure('Units','inches','Position',[0 0 5 4],'PaperPositionMode','auto');

xl=[2000,4000,6000,8000,10000];
types=sendA{1};full_time=recvA{2}-sendA{2};

[unq,temind] = unique(types);u=types(sort(temind));yl=zeros(6,length(xl));

for i=1:length(temind)
    yl(i,:)=full_time(temind(i):temind(i)+length(xl)-1);
end
plot(xl,yl(1,:),'-db',xl,yl(2,:),'-dr',xl,yl(3,:),'--b',xl,yl(4,:),'--r','linewidth',1.5)
h1=legend('MVAPICH2-Ethernet','MVAPICH2-OpenIB','OpenMPI-Ethernet','OpenMPI-OpenIB','Location','northwest');set(h1,'Interpreter','latex');

set(h1,'Interpreter','latex');
 title('Send Receive A Matrix: 32 Processes','interpreter','latex');
 xlabel('Matrix Size N','interpreter','latex');
 ylabel('Time (in seconds)','interpreter','latex');
set(gca,'Units','normalized','FontUnits','points','FontWeight','normal','FontSize',9,'FontName','Times','TickLabelInterpreter', 'latex')
D = f2.PaperPosition;
set(gcf, 'PaperPositionMode','auto')
f2.PaperSize = [D(3) D(4)];
print(f2,'-dpdf',strcat(outfolder,'sendrecvA_32'),'-r0');

f2=figure('Units','inches','Position',[0 0 5 4],'PaperPositionMode','auto');

xl=[2000,4000,6000,8000,10000];
types=sendC{1};full_time=recvC{2}-sendC{2};

[unq,temind] = unique(types);u=types(sort(temind));yl=zeros(6,length(xl));

for i=1:length(temind)
    yl(i,:)=full_time(temind(i):temind(i)+length(xl)-1);
end
plot(xl,yl(1,:),'-db',xl,yl(2,:),'-dr',xl,yl(3,:),'--b',xl,yl(4,:),'--r','linewidth',1.5)
h1=legend('MVAPICH2-Ethernet','MVAPICH2-OpenIB','OpenMPI-Ethernet','OpenMPI-OpenIB','Location','northwest');set(h1,'Interpreter','latex');

set(h1,'Interpreter','latex');
 title('Send Receive C Matrix: 32 Processes','interpreter','latex');
 xlabel('Matrix Size N','interpreter','latex');
 ylabel('Time (in seconds)','interpreter','latex');
set(gca,'Units','normalized','FontUnits','points','FontWeight','normal','FontSize',9,'FontName','Times','TickLabelInterpreter', 'latex')
D = f2.PaperPosition;
set(gcf, 'PaperPositionMode','auto')
f2.PaperSize = [D(3) D(4)];
print(f2,'-dpdf',strcat(outfolder,'sendrecvC_32'),'-r0');