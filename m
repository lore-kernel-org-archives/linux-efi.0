From: Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: Re: [PATCH v1 2/3] firmware loader: fix hung task warning dump
Date: Sun, 26 Oct 2014 23:52:11 +0800
Message-ID: <CACVXFVM6naH5cSeyvqyfg+Hwz09DuWTb=P0joBeKUPy9843gAA@mail.gmail.com>
References: <1414131502-13886-1-git-send-email-hock.leong.kweh@intel.com>
	<1414131502-13886-3-git-send-email-hock.leong.kweh@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1414131502-13886-3-git-send-email-hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kweh Hock Leong <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sam Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ong Boon Leong <boon.leong.ong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Oct 24, 2014 at 2:18 PM, Kweh Hock Leong
<hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> From: "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
> When using request_firmware_nowait() with FW_ACTION_NOHOTPLUG param to
> expose user helper interface, if the user do not react immediately, after
> 120 seconds there will be a hung task warning message dumped as below:
>
> [ 3000.784235] INFO: task kworker/0:0:8259 blocked for more than 120 seconds.
> [ 3000.791281]       Tainted: G            E 3.16.0-rc1-yocto-standard #41
> [ 3000.798082] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 3000.806072] kworker/0:0     D cd0075c8     0  8259      2 0x00000000
> [ 3000.812765] Workqueue: events request_firmware_work_func
> [ 3000.818253]  cd375e18 00000046 0000000e cd0075c8 000000f0 cd40ea00 cd375fec 1b883e89
> [ 3000.826374]  0000026b cd40ea00 80000000 00000001 cd0075c8 00000000 cd375de4 c119917f
> [ 3000.834492]  cd563360 cd375df4 c119a0ab cd563360 00000000 cd375e24 c119a1d6 00000000
> [ 3000.842616] Call Trace:
> [ 3000.845252]  [<c119917f>] ? kernfs_next_descendant_post+0x3f/0x50
> [ 3000.851543]  [<c119a0ab>] ? kernfs_activate+0x6b/0xc0
> [ 3000.856790]  [<c119a1d6>] ? kernfs_add_one+0xd6/0x130
> [ 3000.862047]  [<c15fdb02>] schedule+0x22/0x60
> [ 3000.866548]  [<c15fd195>] schedule_timeout+0x175/0x1d0
> [ 3000.871887]  [<c119b391>] ? __kernfs_create_file+0x71/0xa0
> [ 3000.877574]  [<c119bb9a>] ? sysfs_add_file_mode_ns+0xaa/0x180
> [ 3000.883533]  [<c15fe84f>] wait_for_completion+0x6f/0xb0
> [ 3000.888961]  [<c1065200>] ? wake_up_process+0x40/0x40
> [ 3000.894219]  [<c13cb600>] _request_firmware+0x750/0x9f0
> [ 3000.899666]  [<c1382a7f>] ? n_tty_receive_buf2+0x1f/0x30
> [ 3000.905200]  [<c13cba02>] request_firmware_work_func+0x22/0x50
> [ 3000.911235]  [<c10550d2>] process_one_work+0x122/0x380
> [ 3000.916571]  [<c1055859>] worker_thread+0xf9/0x470
> [ 3000.921555]  [<c1055760>] ? create_and_start_worker+0x50/0x50
> [ 3000.927497]  [<c1055760>] ? create_and_start_worker+0x50/0x50
> [ 3000.933448]  [<c105a5ff>] kthread+0x9f/0xc0
> [ 3000.937850]  [<c15ffd40>] ret_from_kernel_thread+0x20/0x30
> [ 3000.943548]  [<c105a560>] ? kthread_worker_fn+0x100/0x100
>
> This patch change the wait_for_completion() function call to
> wait_for_completion_interruptible() function call for solving the issue.
>
> Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Kweh, Hock Leong <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Acked-by: Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

Thanks,
