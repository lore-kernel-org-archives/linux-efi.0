From: David Vrabel <david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Xen-devel] [GIT PULL] EFI ARM Xen support
Date: Tue, 17 May 2016 11:40:14 +0100
Message-ID: <573AF50E.9090206@citrix.com>
References: <20160514190410.GA2283@codeblueprint.co.uk>
 <alpine.DEB.2.10.1605171109170.2494@sstabellini-ThinkPad-X260>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.10.1605171109170.2494@sstabellini-ThinkPad-X260>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stefano Stabellini <sstabellini-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Shannon Zhao <zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 17/05/16 11:12, Stefano Stabellini wrote:
> On Sat, 14 May 2016, Matt Fleming wrote:
>> Folks,
>>
>> Please pull the following branch which contains support for Xen on ARM
>> EFI platforms.
>>
>> This merge includes a merge of Stefano's xen/linux-next branch to pull
>> in the prerequisites required for Shannon's commit:
>>
>>   11ee5491e5ff ("Xen: EFI: Parse DT parameters for Xen specific UEFI")
>>
>> as it needs both the latest changes in the EFI 'next' branch (now
>> tip/efi/core) and xen/linux-next.
>>
>> I have intentionally not included the individual patches as I would
>> normally do in a pull request, so that commit history created by my
>> merging of Stefano's branch is preserved, and so that there's no way
>> to accidentally apply the patches individually.
>>
>> The following changes since commit 6c5450ef66816216e574885cf8d3ddb31ef77428:
>>
>>   efivarfs: Make efivarfs_file_ioctl() static (2016-05-07 07:06:13 +0200)
>>
>> are available in the git repository at:
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git efi/arm-xen
>>
>> for you to fetch changes up to 11ee5491e5ff519e0d3a7018eb21351cb6955a98:
>>
>>   Xen: EFI: Parse DT parameters for Xen specific UEFI (2016-05-14 19:31:01 +0100)
> 
> Is this arrangement working for everybody, in particular the tip
> maintainers?

Yes.

David
