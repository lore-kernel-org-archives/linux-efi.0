From: Colin Walters <walters@verbum.org>
Subject: Re: [PATCH] systemd: mount the EFI variable
 filesystem
Date: Wed, 31 Oct 2012 09:04:30 -0400
Message-ID: <1351688670.9230.4.camel@lenny>
References: <1351308202-14628-1-git-send-email-jlee@suse.com>
	<20121028130025.GD7904@tango.0pointer.de>
	<1351477290.21227.7.camel@linux-s257.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <systemd-devel-bounces+gcssd-systemd-devel=m.gmane.org@lists.freedesktop.org>
In-Reply-To: <1351477290.21227.7.camel@linux-s257.site>
List-Unsubscribe: <http://lists.freedesktop.org/mailman/options/systemd-devel>,
	<mailto:systemd-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <http://lists.freedesktop.org/archives/systemd-devel>
List-Post: <mailto:systemd-devel@lists.freedesktop.org>
List-Help: <mailto:systemd-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <http://lists.freedesktop.org/mailman/listinfo/systemd-devel>,
	<mailto:systemd-devel-request@lists.freedesktop.org?subject=subscribe>
Sender: systemd-devel-bounces+gcssd-systemd-devel=m.gmane.org@lists.freedesktop.org
Errors-To: systemd-devel-bounces+gcssd-systemd-devel=m.gmane.org@lists.freedesktop.org
To: joeyli <jlee@suse.com>
Cc: Matt Fleming <matt.fleming@intel.com>, systemd-devel@lists.freedesktop.org, Kay Sievers <kay@vrfy.org>, linux-efi@vger.kernel.org, Jeremy Kerr <jeremy.kerr@canonical.com>, Matthew Garrett <mjg@redhat.com>
List-Id: linux-efi@vger.kernel.org

On Mon, 2012-10-29 at 10:21 +0800, joeyli wrote:

> I tested this patch on my UEFI notebook with latest EFI kernel git tree,
> the efivarfs mounted normally after system boot and I can delete/add EFI
> variable through /sys/firmware/efi/efivars.

This causes systemd to output a warning if the kernel doesn't have an
efivars module.  I suppose to do this kind of thing "right" we'd
have to conditionalize the module loads on available kernel version they
first appeared in?

(Yes, I frequently I boot bleeding edge systemd from git on older
kernels)
