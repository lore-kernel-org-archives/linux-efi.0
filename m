From: David Vrabel <david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Xen-devel] [PATCH v6 7/9] xen: Put EFI machinery in place
Date: Mon, 23 Jun 2014 10:57:31 +0100
Message-ID: <53A7FA0B.4070106@citrix.com>
References: <1403299768-9955-1-git-send-email-daniel.kiper@oracle.com> <1403299768-9955-8-git-send-email-daniel.kiper@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1403299768-9955-8-git-send-email-daniel.kiper-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Kiper <daniel.kiper-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org
Cc: mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, jeremy-TSDbQ3PG+2Y@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ian.campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, andrew.cooper3-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, jbeulich-IBi9RG/b67k@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, eshelton-e+AXbWqSrlAAvxtiuMwx3w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 20/06/14 22:29, Daniel Kiper wrote:
> This patch enables EFI usage under Xen dom0. Standard EFI Linux
> Kernel infrastructure cannot be used because it requires direct
> access to EFI data and code. However, in dom0 case it is not possible
> because above mentioned EFI stuff is fully owned and controlled
> by Xen hypervisor. In this case all calls from dom0 to EFI must
> be requested via special hypercall which in turn executes relevant
> EFI code in behalf of dom0.
> 
> When dom0 kernel boots it checks for EFI availability on a machine.
> If it is detected then artificial EFI system table is filled.
> Native EFI callas are replaced by functions which mimics them
> by calling relevant hypercall. Later pointer to EFI system table
> is passed to standard EFI machinery and it continues EFI subsystem
> initialization taking into account that there is no direct access
> to EFI boot services, runtime, tables, structures, etc. After that
> system runs as usual.

Reviewed-by: David Vrabel <david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>

(With or without the change suggested by Stefano).

Thanks.

David
