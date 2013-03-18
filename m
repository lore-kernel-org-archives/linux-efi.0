From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: Curious crash with secure variables
Date: Mon, 18 Mar 2013 18:04:37 +0000
Message-ID: <51475735.40201@console-pimps.org>
References: <1363593684.2412.5.camel@dabdike.int.hansenpartnership.com>    <1363607345.15011.339.camel@mfleming-mobl1.ger.corp.intel.com>   <1363616613.2412.19.camel@dabdike.int.hansenpartnership.com>   <51472C81.5020801@console-pimps.org>  <1363619058.11342.74.camel@i7.infradead.org>  <51472FD2.6020205@console-pimps.org> <1363620768.11342.76.camel@i7.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1363620768.11342.76.camel-W2I5cNIroUsVm/YvaOjsyQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jordan L Justen <jordan.l.justen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 03/18/2013 03:32 PM, David Woodhouse wrote:
> On Mon, 2013-03-18 at 15:16 +0000, Matt Fleming wrote:
>>
>> See,
>>
>>   commit 53b87cf0 ("x86, mm: Include the entire kernel memory map in trampoline_pgd"),
>>   commit 185034e7 ("x86, efi: 1:1 pagetable mapping for virtual EFI calls"),
>>   commit da5a108d05b4 ("x86/kernel: remove tboot 1:1 page table creation code") and 
>>   commit bd52276fa1d4 ("x86-64/efi: Use EFI to deal with platform wall clock (again)")
>>
>>  and the two revert commits from Linus, be354f40 and 11520e5e.
> 
> Thanks. That seems like a rather scary approach. I was thinking of just
> setting up a dedicated kernel thread for making runtime services calls,
> and giving it some "userspace" page tables with a 1:1 mapping. No
> messing around with %cr3 directly.

How would that work? Would it be a real, executable thread context as
opposed to just an address space? In which case would we be passing data
to this thread for it to execute on our behalf? One thing to be aware of
is that sometimes we need to make EFI calls when the sky is falling,
such as writing EFI variables in the pstore code paths when crashing.
Scheduling things at that point may be difficult.

Provided that you can still do things like that, it seems like a nice
solution.

-- 
Matt Fleming, Intel Open Source Technology Center
