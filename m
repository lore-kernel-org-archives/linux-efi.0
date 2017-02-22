From: Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: Re: [PATCH V10 07/10] efi: print unrecognized CPER section
Date: Wed, 22 Feb 2017 01:12:42 +0000
Message-ID: <20170222011241.GX21222@n2100.armlinux.org.uk>
References: <1487188282-2568-1-git-send-email-tbaicar@codeaurora.org>
 <1487188282-2568-8-git-send-email-tbaicar@codeaurora.org>
 <58AC9093.5020303@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Content-Disposition: inline
In-Reply-To: <58AC9093.5020303@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: James Morse <james.morse@arm.com>
Cc: linux-efi@vger.kernel.org, kvm@vger.kernel.org, matt@codeblueprint.co.uk, catalin.marinas@arm.com, Tyler Baicar <tbaicar@codeaurora.org>, will.deacon@arm.com, linux-kernel@vger.kernel.org, paul.gortmaker@windriver.com, lv.zheng@intel.com, kvmarm@lists.cs.columbia.edu, fu.wei@linaro.org, zjzhang@codeaurora.org, robert.moore@intel.com, linux-acpi@vger.kernel.org, eun.taik.lee@samsung.com, shijie.huang@arm.com, labbott@redhat.com, lenb@kernel.org, harba@codeaurora.org, john.garry@huawei.com, marc.zyngier@arm.com, punit.agrawal@arm.com, rostedt@goodmis.org, nkaje@codeaurora.org, sandeepa.s.prabhu@gmail.com, linux-arm-kernel@lists.infradead.org, devel@acpica.org, rjw@rjwysocki.net, rruigrok@codeaurora.org, astone@redhat.com, hanjun.guo@linaro.org, pbonzini@redhat.com, akpm@linux-foundation.org, bristot@redhat.com, shiju.jose@huawei.com
List-Id: linux-efi@vger.kernel.org

On Tue, Feb 21, 2017 at 07:10:11PM +0000, James Morse wrote:
> Hi Tyler,
> 
> On 15/02/17 19:51, Tyler Baicar wrote:
> > +	} else {
> > +		const void *unknown_err;
> > +
> > +		unknown_err = acpi_hest_generic_data_payload(gdata);
> > +		printk("%ssection type: %pUl\n", newpfx, sec_type);
> > +		printk("%ssection length: %d\n", newpfx,
> 
> Nit: please use the "%s""section... that this file consistently uses. This means
> this code will still work as expected when someone adds '%ss' support to printk!

No.  That is wrong:

"%s""section" is stored in memory as bytes containing:

'%' 's' 's' 'e' 'c' 't' 'i' 'o' 'n'

whereas "%ssection" is stored in memory as bytes containing:

'%' 's' 's' 'e' 'c' 't' 'i' 'o' 'n'

They're exactly the same, so when printk() comes to parse the string, it
sees exactly the same byte sequence.  So, the only thing that's happening
is code obfuscation for no good reason what so ever.

If you don't believe me, run some build tests and look at the resulting
strings... also look at the C standard.  "Adjacent string literal tokens
are concatenated."

Please get rid of this obfuscation.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
