%%
clear all;close all;
for monkeys = [640:641 642:647]
    for hemi = 1:3
        if exist(sprintf('/experiments/m%d_array/mapping/m%dr%d.cmp',monkeys,monkeys,hemi),'file')
            am = arraymap(sprintf('/experiments/m%d_array/mapping/m%dr%d.cmp',monkeys,monkeys,hemi));
            am.showmap;
            print(gcf,'-depsc',sprintf('/experiments/m%d_array/mapping/m%dr%d.eps',monkeys,monkeys,hemi));
            close(gcf);
            clear am;
        end
        if exist(sprintf('/experiments/m%d_array/mapping/m%dl%d.cmp',monkeys,monkeys,hemi),'file')
            am = arraymap(sprintf('/experiments/m%d_array/mapping/m%dl%d.cmp',monkeys,monkeys,hemi));
            am.showmap;
            print(gcf,'-depsc',sprintf('/experiments/m%d_array/mapping/m%dl%d.eps',monkeys,monkeys,hemi));
            close(gcf);
            clear am;
        end
    end
end