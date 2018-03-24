From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: efisubsys_init takes more than a few milliseconds
Date: Sat, 24 Mar 2018 22:35:54 +0000
Message-ID: <CAKv+Gu84h2+zofb4v-QrVE7rqCrGC7MaHEw7tB+z2J8DczjoKw@mail.gmail.com>
References: <305249de-7892-fca4-b462-a493aa65d177@molgen.mpg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <305249de-7892-fca4-b462-a493aa65d177@molgen.mpg.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Paul Menzel <pmenzel+linux-efi@molgen.mpg.de>
Cc: linux-efi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

Hello Paul,

On 24 March 2018 at 22:10, Paul Menzel <pmenzel+linux-efi@molgen.mpg.de> wr=
ote:
> Dear Ard,
>
>
> According to `initcall_debug`, `efisubsys_init` takes more than a few
> milliseconds to execute on a Dell XPS 13 9370 (Intel(R) Core(TM) i7-8550U
> CPU @ 1.80GHz).
>
>> ```
>> [=E2=80=A6]
>> [ 0.144474] calling  efisubsys_init+0x0/0x2cf @ 1
>> [ 0.144474] Registered efivars operations
>> [ 0.173690] initcall efisubsys_init+0x0/0x2cf returned 0 after 27343 use=
cs
>> [=E2=80=A6]
>> ```
>
>
> To get a vanilla Linux kernel to boot in well under one second, it=E2=80=
=99d be nice
> if the time could be improved. Do you know, why it takes so long?
>
> According to `bootgraph.py` from pm-graph [1][2] it takes even a little
> longer.
>
>> efisubsys_init: start=3D690.841, end=3D720.493, length(w/o overhead)=3D3=
1.250
>> ms, return=3D0
>
>
> There are several dozen calls to `virt_efi_get_next_variable()` all but o=
ne
> taking around 0.335 ms. This path needs to be optimized. Is that possible=
?
>

That depends. These are firmware calls, so to make these calls faster,
you need to modify the firmware, not the kernel.

We may be able to make more intrusive changes to get rid of this
delay, e.g., spin up a special kernel thread, but I'd have to check in
more detail. In the mean time, you can try passing 'efi=3Dnoruntime' to
the kernel.


> To reproduce this, clone the pm-graph repository [2], use `sudo
> ./bootgraph.py -f -fstat -maxdepth 10 -manual` to see what to add to
> `/boot/grub/grub.cfg`. Then reboot, and execute `sudo ./bootgraph.py -f
> -fstat -maxdepth 10`.
>
> If your system is powerful enough, you can use a higher maximum depth. I
> didn=E2=80=99t get around how `-cgfilter` works to get smaller HTML files=
.
>
>
> Kind regards,
>
> Paul
>
>
> [1] https://01.org/suspendresume
> [2] https://github.com/01org/pm-graph
