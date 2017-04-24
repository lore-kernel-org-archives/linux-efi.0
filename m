From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [PATCH 3/3 v2] xen: Implement EFI reset_system callback
Date: Mon, 24 Apr 2017 14:23:03 -0400
Message-ID: <13e9e915-ecd8-0664-6789-d6e7887182e6@oracle.com>
References: <20170424175839.5262-1-julien.grall@arm.com>
 <20170424175839.5262-4-julien.grall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20170424175839.5262-4-julien.grall@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Julien Grall <julien.grall@arm.com>, xen-devel@lists.xen.org
Cc: mark.rutland@arm.com, Juergen Gross <jgross@suse.com>, linux-efi@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, sstabellini@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-arm-kernel@lists.infradead.org
List-Id: linux-efi@vger.kernel.org

On 04/24/2017 01:58 PM, Julien Grall wrote:
> When rebooting DOM0 with ACPI on ARM64, the kernel is crashing with the stack
> trace [1].
>
> This is happening because when EFI runtimes are enabled, the reset code
> (see machine_restart) will first try to use EFI restart method.
>
> However, the EFI restart code is expecting the reset_system callback to
> be always set. This is not the case for Xen and will lead to crash.
>
> The EFI restart helper is used in multiple places and some of them don't
> not have fallback (see machine_power_off). So implement reset_system
> callback as a call to xen_reboot when using EFI Xen.

Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
