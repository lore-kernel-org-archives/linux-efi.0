From: Zbigniew =?utf-8?Q?J=C4=99drzejewski-Szmek?= <zbyszek@in.waw.pl>
Subject: Re: [PATCH] Add syste-firmware-efi-efivars.mount
 for support automount EFI variable filesystem
Date: Wed, 24 Oct 2012 14:12:46 +0200
Message-ID: <20121024121246.GU19454@in.waw.pl>
References: <1351075322-3824-1-git-send-email-jlee@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <systemd-devel-bounces+gcssd-systemd-devel=m.gmane.org@lists.freedesktop.org>
Content-Disposition: inline
In-Reply-To: <1351075322-3824-1-git-send-email-jlee@suse.com>
List-Unsubscribe: <http://lists.freedesktop.org/mailman/options/systemd-devel>,
	<mailto:systemd-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <http://lists.freedesktop.org/archives/systemd-devel>
List-Post: <mailto:systemd-devel@lists.freedesktop.org>
List-Help: <mailto:systemd-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <http://lists.freedesktop.org/mailman/listinfo/systemd-devel>,
	<mailto:systemd-devel-request@lists.freedesktop.org?subject=subscribe>
Sender: systemd-devel-bounces+gcssd-systemd-devel=m.gmane.org@lists.freedesktop.org
Errors-To: systemd-devel-bounces+gcssd-systemd-devel=m.gmane.org@lists.freedesktop.org
To: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Cc: linux-efi@vger.kernel.org, systemd-devel@lists.freedesktop.org, Kay Sievers <kay@vrfy.org>, "Lee, Chun-Yi" <jlee@suse.com>, Matt Fleming <matt.fleming@intel.com>, Jeremy Kerr <jeremy.kerr@canonical.com>, Matthew Garrett <mjg@redhat.com>
List-Id: linux-efi@vger.kernel.org

On Wed, Oct 24, 2012 at 06:42:02PM +0800, Lee, Chun-Yi wrote:
> Add units/sys-firmware-efi-efivars.mount rule for support automount EFI variable filesystem
> ---
Hi,

in systemd parlance, automount means autofs mount, but to have that, a
second .automount unit is needed.  Please have a look at
http://cgit.freedesktop.org/systemd/systemd/tree/units/proc-sys-fs-binfmt_misc.automount
vs
http://cgit.freedesktop.org/systemd/systemd/tree/units/proc-sys-fs-binfmt_misc.mount .
Now the question is whether the loading of the fs is slow enough to
matter, ie. if it is actually beneficial to use automount instead of
mounting directly.  Since the fs can be compiled as a module, than it
probably is.

Also, would be nice to add a Documentation= line like in
proc-sys-fs-binfmt_misc.automount.

>  units/sys-firmware-efi-efivars.mount |   17 +++++++++++++++++
>  1 files changed, 17 insertions(+), 0 deletions(-)
>  create mode 100644 units/sys-firmware-efi-efivars.mount

Zbyszek
