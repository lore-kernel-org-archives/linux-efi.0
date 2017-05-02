From: Julien Grall <julien.grall@arm.com>
Subject: Re: [PATCH 0/3 v2] xen: Implement EFI reset_system callback
Date: Tue, 2 May 2017 10:08:24 +0100
Message-ID: <33472949-4748-f03e-cae9-65bd5f54c2f7@arm.com>
References: <20170424175839.5262-1-julien.grall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20170424175839.5262-1-julien.grall@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: xen-devel@lists.xen.org, sstabellini@kernel.org, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>
Cc: mark.rutland@arm.com, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: linux-efi@vger.kernel.org

Hi all,

It looks like the series has fully been acked, can someone merge this 
into xentip?

Cheers,

On 04/24/2017 06:58 PM, Julien Grall wrote:
> Hi all,
>
> This small patch series implements EFI reset_system callback when using EFI
> Xen. Without this, it will not be possible to reboot/power off ARM64 DOM0
> when using ACPI.
>
> Cheers,
>
> Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> Cc: Juergen Gross <jgross@suse.com>
>
> Julien Grall (3):
>   xen: Export xen_reboot
>   arm/xen: Consolidate calls to shutdown hypercall in a single helper
>   xen: Implement EFI reset_system callback
>
>  arch/arm/xen/efi.c       |  2 +-
>  arch/arm/xen/enlighten.c | 16 ++++++++++------
>  arch/x86/xen/efi.c       |  2 +-
>  arch/x86/xen/enlighten.c |  2 +-
>  drivers/xen/efi.c        | 18 ++++++++++++++++++
>  include/xen/xen-ops.h    |  5 +++++
>  6 files changed, 36 insertions(+), 9 deletions(-)
>

-- 
Julien Grall
