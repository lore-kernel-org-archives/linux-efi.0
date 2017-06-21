From: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
Subject: Re: [PATCH v6 26/34] iommu/amd: Allow the AMD IOMMU to work with
	memory encryption
Date: Wed, 21 Jun 2017 13:40:14 -0500
Message-ID: <26d48eb1-4d33-4abf-f169-3ce86aef22fe@amd.com>
References: <20170607191309.28645.15241.stgit@tlendack-t1.amdoffice.net>
	<20170607191745.28645.81756.stgit@tlendack-t1.amdoffice.net>
	<20170614174208.p2yr5exs4b6pjxhf@pd.tnic>
	<0611d01a-19f8-d6ae-2682-932789855518@amd.com>
	<20170615094111.wga334kg2bhxqib3@pd.tnic>
	<20170621153721.GP30388@8bytes.org>
	<20170621165921.tv2jfhf5dz7hsjsy@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20170621165921.tv2jfhf5dz7hsjsy-fF5Pk5pvG8Y@public.gmane.org>
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
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Brijesh Singh <brijesh.singh-5C7GfCeVMHo@public.gmane.org>, Toshimitsu Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Larry Woodman <lwoodman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kasan-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, "Michael S. Tsirkin" <mst>
List-Id: linux-efi@vger.kernel.org

On 6/21/2017 11:59 AM, Borislav Petkov wrote:
> On Wed, Jun 21, 2017 at 05:37:22PM +0200, Joerg Roedel wrote:
>>> Do you mean this is like the last exception case in that document above:
>>>
>>> "
>>>    - Pointers to data structures in coherent memory which might be modified
>>>      by I/O devices can, sometimes, legitimately be volatile.  A ring buffer
>>>      used by a network adapter, where that adapter changes pointers to
>>>      indicate which descriptors have been processed, is an example of this
>>>      type of situation."
>>>
>>> ?
>>
>> So currently (without this patch) the build_completion_wait function
>> does not take a volatile parameter, only wait_on_sem() does.
>>
>> Wait_on_sem() needs it because its purpose is to poll a memory location
>> which is changed by the iommu-hardware when its done with command
>> processing.
> 
> Right, the reason above - memory modifiable by an IO device. You could
> add a comment there explaining the need for the volatile.
> 
>> But the 'volatile' in build_completion_wait() looks unnecessary, because
>> the function does not poll the memory location. It only uses the
>> pointer, converts it to a physical address and writes it to the command
>> to be queued.
> 
> Ok.

Ok, so the (now) current version of the patch that doesn't change the
function signature is the right way to go.

Thanks,
Tom

> 
> Thanks.
> 
