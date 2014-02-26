From: One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
Subject: Re: [PATCH 12/12] Add option to automatically set trusted_kernel
 when in Secure Boot mode
Date: Wed, 26 Feb 2014 22:41:41 +0000
Message-ID: <20140226224141.1741a746@alan.etchedpixels.co.uk>
References: <1393445473-15068-1-git-send-email-matthew.garrett@nebula.com>
	<1393445473-15068-13-git-send-email-matthew.garrett@nebula.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1393445473-15068-13-git-send-email-matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, 26 Feb 2014 15:11:13 -0500
Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org> wrote:

> UEFI Secure Boot provides a mechanism for ensuring that the firmware will
> only load signed bootloaders and kernels. Certain use cases may also
> require that the kernel prevent userspace from inserting untrusted kernel
> code at runtime. Add a configuration option that enforces this automatically
> when enabled.

I think you have a load more cases to attempt to paper over before you
even pretend to achieve that goal. Firewire for example. Also it only
remotely begins to work if you also force CAP_SYS_RAWIO off globally as
you need to force off things like raw command issuing to various
controllers (especially as some of that code is written on the basis that
'its RAWIO, screw making it secure and doing all the checks we could
bother with'.

RAWIO also disables things like CPU msr access - which is also quite
adequate for subverting a kernel.

Another issue that needs addressing is firmware. Quite a few of our
request_firmware cases load device firmware which is not signed into DMA
capable hardware. Probably also worth checking what the
architectural guarantees on bogus microcode updates is. Maybe we need
firmware signing for such cases to match the mod signing ?

I'm trying to think what else. Possibly disabling it on Pentium-M with
the rep movs erratum (Y19) as it's quite possible to set up suitable
adjacent page sets in user space via the graphics.

Alan
