From: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
Subject: Re: [PATCH v6 26/34] iommu/amd: Allow the AMD IOMMU to work with
	memory encryption
Date: Thu, 15 Jun 2017 09:59:45 -0500
Message-ID: <921153f5-1528-31d8-b815-f0419e819aeb@amd.com>
References: <20170607191309.28645.15241.stgit@tlendack-t1.amdoffice.net>
	<20170607191745.28645.81756.stgit@tlendack-t1.amdoffice.net>
	<20170614174208.p2yr5exs4b6pjxhf@pd.tnic>
	<0611d01a-19f8-d6ae-2682-932789855518@amd.com>
	<20170615094111.wga334kg2bhxqib3@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20170615094111.wga334kg2bhxqib3-fF5Pk5pvG8Y@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Brijesh Singh <brijesh.singh-5C7GfCeVMHo@public.gmane.org>, Toshimitsu Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Larry Woodman <lwoodman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kasan-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, "Michael S. Tsirkin" <mst>
List-Id: linux-efi@vger.kernel.org

On 6/15/2017 4:41 AM, Borislav Petkov wrote:
> On Wed, Jun 14, 2017 at 03:40:28PM -0500, Tom Lendacky wrote:
>> I was trying to keep all the logic for it here in the SME related files
>> rather than put it in the iommu code itself. But it is easy enough to
>> move if you think it's worth it.
> 
> Yes please - the less needlessly global symbols, the better.

Ok.

> 
>>> Also, you said in another mail on this subthread that c->microcode
>>> is not yet set. Are you saying, that the iommu init gunk runs before
>>> init_amd(), where we do set c->microcode?
>>>
>>> If so, we can move the setting to early_init_amd() or so.
>>
>> I'll look into that.
> 
> And I don't think c->microcode is not set by the time we init the iommu
> because, AFAICT, we do the latter in pci_iommu_init() and that's a
> rootfs_initcall() which happens later then the CPU init stuff.

Actually the detection routine, amd_iommu_detect(), is part of the
IOMMU_INIT_FINISH macro support which is called early through mm_init()
from start_kernel() and that routine is called before init_amd().

> 
>> I'll look into simplifying the checks.
> 
> Something like this maybe?
> 
> 	if (rev >= 0x1205)
> 		return true;
> 
> 	if (rev <= 0x11ff && rev >= 0x1126)
> 		return true;
> 
> 	return false;

Yup, something like that.

> 
>>> WARNING: Use of volatile is usually wrong: see Documentation/process/volatile-considered-harmful.rst
>>> #134: FILE: drivers/iommu/amd_iommu.c:866:
>>> +static void build_completion_wait(struct iommu_cmd *cmd, volatile u64 *sem)
>>>
>>
>> The semaphore area is written to by the device so the use of volatile is
>> appropriate in this case.
> 
> Do you mean this is like the last exception case in that document above:
> 
> "
>    - Pointers to data structures in coherent memory which might be modified
>      by I/O devices can, sometimes, legitimately be volatile.  A ring buffer
>      used by a network adapter, where that adapter changes pointers to
>      indicate which descriptors have been processed, is an example of this
>      type of situation."
> 
> ?
> 
> If so, it did work fine until now, without the volatile. Why is it
> needed now, all of a sudden?

If you run checkpatch against the whole amd_iommu.c file you'll see that
same warning for the wait_on_sem() function.  The checkpatch warning
shows up now because I modified the build_completion_wait() function as
part of the support to use iommu_virt_to_phys().

Since I'm casting the arg to iommu_virt_to_phys() no matter what I can
avoid the signature change to the build_completion_wait() function and
avoid this confusion in the future.

Thanks,
Tom

> 
