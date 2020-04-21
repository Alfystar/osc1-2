function [chk,Qup,Qdown,Qstill,score,rimbalzi] = PongEffect(xb0,yb0,ys0,Qup,Qdown,Qstill,figOnOff)


global L H alpha gamma eps V
global Ln Hn Vn velSig    % Settori Discretizzati

% [xb0, yb0]: posizione iniziale della pallina
% [0, yp0]:   posizione iniziale della barretta

Lb = 1;                 % lunghezza della barretta
theta = 0:0.01:2*pi;
rad = 0.2;

Figura = figOnOff;

if Figura == 1
    close all
    figure(1)
    hold on
    box on
    axis([-1 L+1 -1 H+1])
    % disegniamo i bordi del campo
    h1 = line([0 L],[H,H]);
    h1.Color = [0,0,0];
    h1.LineWidth = 3;
    h2 = line([L,L],[H,0]);
    h2.Color = [0,0,0];
    h2.LineWidth = 3;
    h3 = line([0,L],[0,0]);
    h3.Color = [0,0,0];
    h3.LineWidth = 3;
    hT1 = line([L,L],[1,2]);
    hT1.Color = [1,0,0];
    hT1.LineWidth = 6;
    hT1 = line([L,L],[6,7]);
    hT1.Color = [1,0,0];
    hT1.LineWidth = 6;
    
    for i = 1 : Ln
        l = line([0 L],[i/Ln*H,i/Ln*H]);
        l.Color = [0,0,0];
        l.LineWidth = 1;
    end
    
    for i = 1 : Hn
        l = line([i/Hn*L i/Hn*L],[0,H]);
        l.Color = [0,0,0];
        l.LineWidth = 1;
    end
    
    for i = 1 : length(V)
        %         xb+rad*cos(theta),yb+rad*sin(theta)
        ball = fill(0.1*cos(theta)-0.5,V(i)+0.1*sin(theta),[0,0.5,0.5]);
    end
    
    
end

xb = xb0; yb = yb0; ys = ys0;                     % posizioni correnti di pallina e barretta
vx = 0.1; vy = 0.1;                               % velocit� iniziale arbitraria
vb = 0.2;                                         % velocit� della barretta COSTANTE

flagFirst = 1;
maxiter = 10000;
score = 0;

[i1n, i2n, i3n, i4n ,i5n] = state2index(xb,yb,ys,vx,vy);

% finch� la pallina non finisce oltre la barretta...
counter = 0;
while xb > 0 && counter < maxiter
    % ricompensa
    reward = 0;
    
    if Figura == 1
        % disegniamo la posizione corrente della pallina
        
        i5n
        if(i5n == 1) % neg
            C = [0.8,0,0];
        elseif(i5n == 2) % ~0
            C = [0,0,0];
        elseif(i5n == 3) % pos
            C = [0,0.8,0];
        end
        
        ball = patch(xb+rad*cos(theta),yb+rad*sin(theta),C);
        
        % disegniamo la posizione corrente della barretta
        bar = line([0,0],[ys+Lb,ys-Lb]);
        barCenter = fill(0.1*cos(theta),ys+0.1*sin(theta),[0.8,0,0]);
        bar.Color = [0,0,0];
        bar.LineWidth = 10;
        htxt = text(1,H+0.5, strcat('rimbalzi:',num2str(counter)) );
        hscore = text(4,H+0.5, strcat('punteggio:',num2str(score)) );
        hscore.Color = [1,0,0];
        pause(0.001)
    end
    
    
    
    
    [i1, i2, i3, i4 ,i5] = state2index(xb,yb,ys,vx,vy);
    
    
    
    % aggiorniamo la posizione della pallina
    xb = xb+vx;
    yb = yb+vy;
    
    % aggiorniamo lo stato della pallina
    
    % controlliamo se la pallina sbatte contro un bordo
    if (xb >= L-rad) && (vx >= 0)  % tocca il fondo
        vx = -vx;
        if (yb >= 1 && yb <= 2) || (yb >= 6 && yb <= 7)
            reward = 5;
            score = score + 1;
        end
    elseif (yb >= H-rad) && (vy >= 0)  %tocca il bordo superiore
        vy = -vy;
    elseif (yb <= rad) && (vy <= 0)    %tocca il bordo inferiore
        vy = -vy;
    end
    
    % sassano aggiornava tutto tranne i3 qua
    %[i1n, i2n, i3n, i4n ,i5n] = state2index(xb,yb,ys,vx,vy);
    
    % controlliamo se la barretta � in grado di respingere la pallina, e in
    % caso assegno il Reward_K+1
    if (xb <= rad) && (yb+rad >= ys-Lb) && (yb-rad <= ys+Lb)
        vx = -vx;
        if yb+rad <= ys-0.33*Lb || yb-rad >= ys+0.33*Lb
            lambda = rand;
            vy = 0.5*vy+(-0.02*lambda+(1-lambda)*0.02);
        end
        reward = 1;
        counter = counter+1;
    end
    
    
    
    % aggiorniamo la posizione della barretta con strategia epsilon-greedy
    
    coin = rand;
    if coin > eps
        if Qup(i1,i2,i3,i4,i5) >= Qdown(i1,i2,i3,i4,i5) && Qup(i1,i2,i3,i4,i5) >= Qstill(i1,i2,i3,i4,i5) && (ys+Lb <= H-vb)
            ys = ys+vb;
            ctr = 1;
        elseif Qdown(i1,i2,i3,i4,i5) > Qup(i1,i2,i3,i4,i5) && Qdown(i1,i2,i3,i4,i5) >= Qstill(i1,i2,i3,i4,i5) && (ys-Lb >= vb)
            ys = ys-vb;
            ctr = -1;
        else
            ys = ys;
            ctr = 0;
        end
    elseif coin < eps
        rnd_ctr = rand;
        if rnd_ctr < 0.33 && (ys+Lb <= H-vb)
            ys = ys+vb;
            ctr = 1;
        elseif rnd_ctr >= 0.33 && rnd_ctr < 0.66 && (ys-Lb >= vb)
            ys = ys-vb;
            ctr = -1;
        else
            ys = ys;
            ctr = 0;
        end
    end
    
    % aggiorniamo lo stato della barretta
    %     [~,clsIdx] = min(abs(V-ys));
    %     i3n = clsIdx;
    
    [i1n, i2n, i3n, i4n ,i5n] = state2index(xb,yb,ys,vx,vy);
    
    if (Figure == 0 ) % procedo con classica RL
        % aggiorniamo le funzioni Q
        % determiniamo la migliore azione per l'iterazione successiva
        if Qup(i1n,i2n,i3n,i4n,i5n) >= Qdown(i1n,i2n,i3n,i4n,i5n) && Qup(i1n,i2n,i3n,i4n,i5n) >= Qstill(i1n,i2n,i3n,i4n,i5n) && (ys+Lb <= H-vb)
            ctrp = 1;
        elseif Qdown(i1n,i2n,i3n,i4n,i5n) > Qup(i1n,i2n,i3n,i4n,i5n) && Qdown(i1n,i2n,i3n,i4n,i5n) >= Qstill(i1n,i2n,i3n,i4n,i5n) && (ys-Lb >= vb)
            ctrp = -1;
        else
            ctrp = 0;
        end
        
        if (xb<=0)
            reward = -100;
        end
        
        % aggiorniamo la funzione Q(X,U) corretta con il valore di Q(X',U')
        if ctr == 1 && ctrp == 1
            Qup(i1,i2,i3,i4,i5) = Qup(i1,i2,i3,i4,i5) + alpha*(reward+gamma*Qup(i1n,i2n,i3n,i4n,i5n)-Qup(i1,i2,i3,i4,i5));
        elseif ctr == 1 && ctrp == 0
            Qup(i1,i2,i3,i4,i5) = Qup(i1,i2,i3,i4,i5) + alpha*(reward+gamma*Qstill(i1n,i2n,i3n,i4n,i5n)-Qup(i1,i2,i3,i4,i5));
        elseif ctr == 1 && ctrp == -1
            Qup(i1,i2,i3,i4,i5) = Qup(i1,i2,i3,i4,i5) + alpha*(reward+gamma*Qdown(i1n,i2n,i3n,i4n,i5n)-Qup(i1,i2,i3,i4,i5));
        elseif ctr == 0 && ctrp == 1
            Qstill(i1,i2,i3,i4,i5) = Qstill(i1,i2,i3,i4,i5) + alpha*(reward+gamma*Qup(i1n,i2n,i3n,i4n,i5n)-Qstill(i1,i2,i3,i4,i5));
        elseif ctr == 0 && ctrp == 0
            Qstill(i1,i2,i3,i4,i5) = Qstill(i1,i2,i3,i4,i5) + alpha*(reward+gamma*Qstill(i1n,i2n,i3n,i4n,i5n)-Qstill(i1,i2,i3,i4,i5));
        elseif ctr == 0 && ctrp == -1
            Qstill(i1,i2,i3,i4,i5) = Qstill(i1,i2,i3,i4,i5) + alpha*(reward+gamma*Qdown(i1n,i2n,i3n,i4n,i5n)-Qstill(i1,i2,i3,i4,i5));
        elseif ctr == -1 && ctrp == 1
            Qdown(i1,i2,i3,i4,i5) = Qdown(i1,i2,i3,i4,i5) + alpha*(reward+gamma*Qup(i1n,i2n,i3n,i4n,i5n)-Qdown(i1,i2,i3,i4,i5));
        elseif ctr == -1 && ctrp == 0
            Qdown(i1,i2,i3,i4,i5) = Qdown(i1,i2,i3,i4,i5) + alpha*(reward+gamma*Qstill(i1n,i2n,i3n,i4n,i5n)-Qdown(i1,i2,i3,i4,i5));
        elseif ctr == -1 && ctrp == -1
            Qdown(i1,i2,i3,i4,i5) = Qdown(i1,i2,i3,i4,i5) + alpha*(reward+gamma*Qdown(i1n,i2n,i3n,i4n,i5n)-Qdown(i1,i2,i3,i4,i5));
        end
    end
    
    if (Figure == 1 ) % procedo con RBF
        
    end
    
    if Figura == 1
        delete(ball)
        delete(bar)
        delete(barCenter)
        delete(htxt)
        delete(hscore)
    end
    
end

rimbalzi = counter;
chk = -1;
end

% X1(Xball)  = Xpalla arrotondato per eccesso (L+1)
% X2(Yball)  = Ypalla arrotondato per eccesso (H+1)
% X3(Ybarr)  = ybarra
% X4(VxBall) = se vx % 1 = neg, 2 = ~0 , 3 = pos
% X5(VyBall) = se vy % 1 = neg, 2 = ~0 , 3 = pos

function [i1, i2, i3, i4 ,i5] = state2index(Xball,Yball,Ybarr,VxBall,VyBall)
global L H V;
global Ln Hn;
% VxBall
% VyBall
i1 = min(max(1,ceil(Xball/L * Ln)),Ln);
i2 = min(max(1,ceil(Yball/H * Hn)),Hn);

[~,i3] = min(abs(V-Ybarr));

if(abs(VxBall)<0.01)
    i4 = 2;
else
    i4 = sign(VxBall) + 2;
end

if(abs(VyBall)<0.01)
    i5 = 2;
else
    i5 = sign(VyBall) + 2;
end

end

function [G] = RBFMatrix (Qup, Qstill, Qdown)

end

function [state] = scalar2vect(Xball,Yball,Ybarr,VxBall,VyBall)
    state = [Xball,Yball,Ybarr,VxBall,VyBall];
end

function [center] = index2state(i1, i2, i3, i4 ,i5)
global L H V;
global Ln Hn;
    center = [
        i1/Ln * L, ...  %Xball center
        i2/Hn * H, ...  %Yball center
        i3/length(V) * V(end), ...      %Ybarr center
        i4-2, ...     %VxBall center
        i5-2 ...      %VyBall center
        ];
end
