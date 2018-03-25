From: Paul Menzel <pmenzel+linux-efi@molgen.mpg.de>
Subject: Re: efisubsys_init takes more than a few milliseconds
Date: Sun, 25 Mar 2018 17:21:39 +0200
Message-ID: <676c44ce-6909-f002-4ea3-0c6f68b6b781@molgen.mpg.de>
References: <305249de-7892-fca4-b462-a493aa65d177@molgen.mpg.de>
 <CAKv+Gu84h2+zofb4v-QrVE7rqCrGC7MaHEw7tB+z2J8DczjoKw@mail.gmail.com>
 <f94af2ed-3492-4db5-c1bc-30c4c1855947@molgen.mpg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <f94af2ed-3492-4db5-c1bc-30c4c1855947@molgen.mpg.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Dear Ard,


On 03/25/2018 09:41 AM, Paul Menzel wrote:

> On 03/24/2018 11:35 PM, Ard Biesheuvel wrote:
> 
>> On 24 March 2018 at 22:10, Paul Menzel wrote:

>>> According to `initcall_debug`, `efisubsys_init` takes more than a few
>>> milliseconds to execute on a Dell XPS 13 9370 (Intel(R) Core(TM) 
>>> i7-8550U CPU @ 1.80GHz).
>>>
>>>> ```
>>>> […]
>>>> [ 0.144474] calling  efisubsys_init+0x0/0x2cf @ 1
>>>> [ 0.144474] Registered efivars operations
>>>> [ 0.173690] initcall efisubsys_init+0x0/0x2cf returned 0 after 27343 
>>>> usecs
>>>> […]
>>>> ```
>>>
>>>
>>> To get a vanilla Linux kernel to boot in well under one second, it’d 
>>> be nice
>>> if the time could be improved. Do you know, why it takes so long?
>>>
>>> According to `bootgraph.py` from pm-graph [1][2] it takes even a little
>>> longer.
>>>
>>>> efisubsys_init: start=690.841, end=720.493, length(w/o overhead)=31.250
>>>> ms, return=0
>>>
>>> There are several dozen calls to `virt_efi_get_next_variable()` all 
>>> but one
>>> taking around 0.335 ms. This path needs to be optimized. Is that 
>>> possible?
>>
>> That depends. These are firmware calls, so to make these calls faster,
>> you need to modify the firmware, not the kernel.
> 
> Yeah, unfortunately, no free firmware runs on this laptop, and Dell 
> doesn’t respond to these kind of reports, as they think, it’s not 
> important.
> 
>> We may be able to make more intrusive changes to get rid of this
>> delay, e.g., spin up a special kernel thread, but I'd have to check in
>> more detail.
> 
> That’d be great.
> 
>> In the mean time, you can try passing 'efi=noruntime' to the kernel.
> 
> Thank you, I didn’t know about that. Unfortunately, initcall_debug still 
> reports the same time although the one message is gone.
> 
> ```
> $ sudo dmesg | grep efisubsys
> [    0.145779] calling  efisubsys_init+0x0/0x2cf @ 1
> [    0.172034] initcall efisubsys_init+0x0/0x2cf returned 0 after 27343 usecs
> ```

Hmm, it looks like, I only edited `/etc/default/grub` and didn’t run 
`sudo update-grub`.

```
$ sudo dmesg | grep efisubsys
[    0.776339] calling  efisubsys_init+0x0/0x2cf @ 1
[    0.776339] initcall efisubsys_init+0x0/0x2cf returned 0 after 0 usecs
```

>>> To reproduce this, clone the pm-graph repository [2], use `sudo
>>> ./bootgraph.py -f -fstat -maxdepth 10 -manual` to see what to add to
>>> `/boot/grub/grub.cfg`. Then reboot, and execute `sudo ./bootgraph.py -f
>>> -fstat -maxdepth 10`.
>>>
>>> If your system is powerful enough, you can use a higher maximum depth. I
>>> didn’t get around how `-cgfilter` works to get smaller HTML files.


Kind regards,

Paul


>>> [1] https://01.org/suspendresume
>>> [2] https://github.com/01org/pm-graph
