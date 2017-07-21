From: Juergen Gross <jgross-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 4.12 26/84] x86/xen/efi: Initialize only the EFI struct
 members used by Xen
Date: Fri, 21 Jul 2017 08:32:57 +0200
Message-ID: <aa8a0a15-a2a6-a5c2-9a40-78481b231268@suse.com>
References: <20170719092322.362625377@linuxfoundation.org>
 <20170719092323.396710042@linuxfoundation.org>
 <20170719103747.GZ4448@olila.local.net-space.pl>
 <20170720083910.aygobq7t7g7laszt@gmail.com> <20170720091639.GA1071@kroah.com>
 <20170720123321.GK9468@olila.local.net-space.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170720123321.GK9468-fJNZiO034lp9pOct4yEdx/3oZC3j2Omk@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Kiper <daniel.kiper-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Boris Ostrovsky <boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, andrew.cooper3-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 20/07/17 14:33, Daniel Kiper wrote:
> On Thu, Jul 20, 2017 at 11:16:39AM +0200, Greg Kroah-Hartman wrote:
>> On Thu, Jul 20, 2017 at 10:39:10AM +0200, Ingo Molnar wrote:
>>>
>>> * Daniel Kiper <daniel.kiper-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
>>>
>>>> Hey Greg,
>>>>
>>>> On Wed, Jul 19, 2017 at 11:43:32AM +0200, Greg Kroah-Hartman wrote:
>>>>> 4.12-stable review patch.  If anyone has any objections, please let me know.
>>>>
>>>> Why did you skip this patch for 4.11? IMO it should be applied there too.
>>>
>>> The thing is, this patch should probaly not even be in v4.12, as it should only
>>> make any difference if there's a separate _bug_ in the kernel.
>>>
>>> This patch makes things more robust going forward, but I question that it needs to
>>> be in -stable.
>>
>> Yeah, good point, I'm going to go drop it entirely from the 4.12-stable
>> tree as it obviously isn't stable material, sorry for not catching that
>> before.
> 
> Wait a minute. IIRC, Juergen told me last week that this patch fixes a bug
> found/assigned by/to him. Juergen? If it is true then I would apply it to
> stable. If I am wrong you can drop it.

I'm not sure both patches (this one and upstream 457ea3f7e97881f) are
needed. I have got a report about a failing boot and with both patches
applied the boot is working. I will ask if 457ea3f7e97881f alone works,
too. If it doesn't I'll request this patch to be added to stable again.


Juergen
