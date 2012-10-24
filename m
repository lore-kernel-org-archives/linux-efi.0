From: Lennart Poettering <lennart@poettering.net>
Subject: Re: [PATCH] Add syste-firmware-efi-efivars.mount
 for support automount EFI variable filesystem
Date: Wed, 24 Oct 2012 16:04:02 +0200
Message-ID: <20121024140401.GA19778@tango.0pointer.de>
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

On Wed, 24.10.12 18:42, Lee, Chun-Yi (joeyli.kernel@gmail.com) wrote:

> Add units/sys-firmware-efi-efivars.mount rule for support automount
> EFI variable filesystem

Good in principle, but as Kay mentioned we probably should not expose
this as units, but just mount it from PID1's C code. More specifically
add it to the table in src/core/mount-setup.c, but make sure to set the
"fatal" bool in the table to false for this entry, to clarify that this
is not a reason to fail.

You probably also want to add the kmod to the table in
src/core/kmod-setup.c since the mount point is not available if the kmod
is not loaded.

Thanks!

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
