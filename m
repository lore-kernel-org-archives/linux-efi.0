From: Matt Fleming <matt@console-pimps.org>
Subject: Re: [PATCH]x86 efi: do not export efi runtime map in case old map
Date: Mon, 2 Jun 2014 12:23:24 +0100
Message-ID: <CADknwL6Xh+egtg3S0JLrt2eogbWB75MWGA19oG-k97_R9LMTfQ@mail.gmail.com>
References: <20140530032010.GA29906@dhcp-16-198.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140530032010.GA29906@dhcp-16-198.nay.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Young <dyoung@redhat.com>
Cc: matt.fleming@intel.com, bp@alien8.de, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, vgoyal@redhat.com
List-Id: linux-efi@vger.kernel.org

On 30 May 2014 04:20, Dave Young <dyoung@redhat.com> wrote:
>
> For ioremapped efi memory aka old_map the virt addresses are not persistant
> across kexec reboot. kexec-tools will read the runtime maps from sysfs then
> pass them to 2nd kernel and assuming kexec efi boot is ok. This will cause
> kexec boot failure.
>
> To address this issue do not export runtime maps in case efi old_map so
> userspace can use no efi boot instead.
>
> Signed-off-by: Dave Young <dyoung@redhat.com>
> ---
>  arch/x86/platform/efi/efi.c | 3 +++
>  1 file changed, 3 insertions(+)

Thanks Dave, applied with acks.
