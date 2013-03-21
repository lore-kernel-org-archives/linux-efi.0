From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: sysfs: cannot create duplicate filename
Date: Thu, 21 Mar 2013 07:44:15 +0000
Message-ID: <514ABA4F.2000601@console-pimps.org>
References: <CAHsu+b-cG+ED6TX5evRTBjR-LwHugW+8-9hnHXAz5DnAioJnUQ@mail.gmail.com>  <5135BD66.1030005@redhat.com>  <1362755479.15011.238.camel@mfleming-mobl1.ger.corp.intel.com>  <513A2B29.8090705@redhat.com>  <1363082900.15011.257.camel@mfleming-mobl1.ger.corp.intel.com>  <513F0734.80600@redhat.com>  <1363106125.15011.263.camel@mfleming-mobl1.ger.corp.intel.com>  <51405943.2000601@redhat.com>  <1363278817.15011.316.camel@mfleming-mobl1.ger.corp.intel.com>  <A5ED84D3BB3A384992CBB9C77DEDA4D41AF68807@USINDEM103.corp.hds.com> <1363618261.14988.4.camel@mfleming-mobl1.ger.corp.intel.com> <514AB534.8080209@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <514AB534.8080209-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>, Andre Heider <a.heider-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 03/21/2013 07:22 AM, Lingzhu Xiang wrote:
> Tested-by: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Great, thanks!

> Reproduced with 3.9-rc3 in QEMU/OVMF. The kernel gets stuck in a loop.
> 
> Verified with 3.9-rc3 with this patch. The kernel survives. efivarfs
> continues working, though some variables won't show up, as expected.
> 
> [    2.033855] efivars: duplicate variable: Boot0001-8be4df61-93ca-11d2-aa0d-00e098032b8c
> 
> This patch has no real impact for users with normal firmware as tested
> before on a Windows 8 logo desktop.
> 
> For the record, here is how I create duplicate variables in QEMU/OVMF:
> 
> OVMF EmuVariableFvbRuntimeDxe emulates nvram with a reserved area of
> memory (ReserveEmuVariableNvStore). But there seems to be some layers
> of cache above this, so directly writing a new duplicate variable here
> won't make a difference. I ended up writing an EFI app to scan the
> entire memory and replace all L"Boot0004" with L"Boot0001", which
> seemed to actually break things (e.g. dmpstore will get stuck).

Thanks for going to such lengths to test this.

-- 
Matt Fleming, Intel Open Source Technology Center
