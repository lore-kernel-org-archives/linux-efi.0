From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v4 2/5] arm: add new asm macro update_sctlr
Date: Mon, 3 Feb 2014 16:57:18 +0000
Message-ID: <20140203165718.GO14112@mudshark.cambridge.arm.com>
References: <1389445524-30623-1-git-send-email-leif.lindholm@linaro.org>
 <1389445524-30623-3-git-send-email-leif.lindholm@linaro.org>
 <20140122112055.GF1621@mudshark.cambridge.arm.com>
 <20140129182805.GF11329@bivouac.eciton.net>
 <1391029124.2488.50.camel@deneb.redhat.com>
 <20140130131247.GG11329@bivouac.eciton.net>
 <20140203103415.GA12187@mudshark.cambridge.arm.com>
 <20140203155542.GI11329@bivouac.eciton.net>
 <20140203160051.GG14112@mudshark.cambridge.arm.com>
 <20140203164636.GJ11329@bivouac.eciton.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20140203164636.GJ11329@bivouac.eciton.net>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Leif Lindholm <leif.lindholm@linaro.org>
Cc: "roy.franz@linaro.org" <roy.franz@linaro.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>, "patches@linaro.org" <patches@linaro.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>, "matt.fleming@intel.com" <matt.fleming@intel.com>, "msalter@redhat.com" <msalter@redhat.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Feb 03, 2014 at 04:46:36PM +0000, Leif Lindholm wrote:
> On Mon, Feb 03, 2014 at 04:00:51PM +0000, Will Deacon wrote:
> > > > > With the two call sites in uefi_phys.S as:
> > > > > 
> > > > > 	ldr	r5, =(CR_M)
> > > > > 	update_sctlr	r12, , r5
> > > > > and
> > > > > 	ldr	r4, =(CR_I | CR_C | CR_M)
> > > > > 	update_sctlr	r12, r4
> > > > 
> > > > These ldr= could be movs, right?
> > > 
> > > The first one could.
> > > The second one could be movw on armv7+.
> > > 
> > > > If so, I definitely prefer this to putting an ldr = into the macro itself
> > > > (option 2).
> > > 
> > > And your preference between 1) and 2) is?
> > 
> > (1), using bic and mov[tw] where possible.
> 
> (1): ok, thanks.
> 
> bic: sure, that was an oversight.
> 
> mov[tw]: why?
> Then we end up battling different available immediate fields in A32/T32
> instruction sets and v5/v6/v7 architecture versions.

I was making the assumption that UEFI was going to be v7 only... is this not
true?

Will
