From: Russell King - ARM Linux <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>
Subject: Re: [PATCH V4 10/10] arm64: KVM: add guest SEA support
Date: Tue, 1 Nov 2016 09:36:28 +0000
Message-ID: <20161101093628.GP1041@n2100.armlinux.org.uk>
References: <1477071013-29563-1-git-send-email-tbaicar@codeaurora.org>
 <1477071013-29563-11-git-send-email-tbaicar@codeaurora.org>
 <20161031100206.GX1041@n2100.armlinux.org.uk>
 <85443ee1-9981-c7e8-fe88-a3aac48c3e80@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <85443ee1-9981-c7e8-fe88-a3aac48c3e80-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Baicar, Tyler" <tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: marc.zyngier-5wv7dgnIgG8@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, robert.moore-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, lv.zheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, nkaje-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, james.morse-5wv7dgnIgG8@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, eun.taik.lee-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, sandeepa.s.prabhu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, shijie.huang-5wv7dgnIgG8@public.gmane.org, rruigrok-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, paul.gortmaker-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org, tomasz.nowicki-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, fu.wei-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Suzuki.Poulose-5wv7dgnIgG8@public.gmane.org, punit.agrawal-5wv7dgnIgG8@public.gmane.org, astone-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.orgha
List-Id: linux-efi@vger.kernel.org

On Mon, Oct 31, 2016 at 04:36:33PM -0600, Baicar, Tyler wrote:
> Hello Russell,
> 
> On 10/31/2016 4:02 AM, Russell King - ARM Linux wrote:
> >The subject line on this patch is misleading - it's not only ARM64
> >specific...
> Thank you for the feedback!
> 
> I only put ARM64 in the subject line because this patch only really adds
> guest SEA support for the ARM64 KVM code. The ARM code had to be edited
> since both the ARM and ARM64 KVM code use arch/arm/kvm/mmu.c. I can change
> the subject line to "arm/arm64: KVM: add guest SEA support" if you think
> that is better.

Yes please, I almost skipped over it while catching up because it didn't
say "arm", it was only that I'd happened to read the cover message that
I'd spotted arch/arm in the diffstat, and then had to go digging for the
changes to review.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
