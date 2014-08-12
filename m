From: Dave Young <dyoung@redhat.com>
Subject: Re: [PATCH 1/5] efi: move noefi early param code out of x86 arch code
Date: Tue, 12 Aug 2014 15:14:43 +0800
Message-ID: <20140812071443.GB14031@darkstar.nay.redhat.com>
References: <1407823822-23829-1-git-send-email-dyoung@redhat.com>
 <53E9B9B3.1050504@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <53E9B9B3.1050504@infradead.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>, Matt Fleming <matt.fleming@intel.com>, rtc-linux@googlegroups.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-efi@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Mark Salter <msalter@redhat.com>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, Leif Lindholm <leif.lindholm@linaro.org>, Ingo Molnar <mingo@redhat.com>, hpa@zytor.com, Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org
List-Id: linux-efi@vger.kernel.org

On 08/11/14 at 11:52pm, Randy Dunlap wrote:
> On 08/11/14 23:10, Dave Young wrote:
> > noefi param can be used for arches other than X86 later, thus move it out of
> > x86 platform code.
> > 
> > Signed-off-by: Dave Young <dyoung@redhat.com>
> > ---
> >  arch/x86/platform/efi/efi.c | 10 +---------
> >  drivers/firmware/efi/efi.c  | 13 +++++++++++++
> >  include/linux/efi.h         |  1 +
> >  3 files changed, 15 insertions(+), 9 deletions(-)
> 
> This line in Documentation/kernel-parameters.txt needs to be updated:
> 
> 	noefi		[X86] Disable EFI runtime services support.

Randy, thanks

Will update the documentation.

Dave
