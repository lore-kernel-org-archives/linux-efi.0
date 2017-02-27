From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC PATCH V1 v4.10-rc3 1/1] acpi: apei: handle GSIV
 notification type
Date: Mon, 27 Feb 2017 15:39:20 -0500
Message-ID: <20170227153920.5f4f6942@gandalf.local.home>
References: <86258A5CC0A3704780874CF6004BA8A62DCAB57E@lhreml502-mbs>
 <20170227185818.GA8577@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
In-Reply-To: <20170227185818.GA8577@windriver.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "matt@codeblueprint.co.uk" <matt@codeblueprint.co.uk>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, Tyler Baicar <tbaicar@codeaurora.org>, "will.deacon@arm.com" <will.deacon@arm.com>, "robert.moore@intel.com" <robert.moore@intel.com>, "lv.zheng@intel.com" <lv.zheng@intel.com>, "Guohanjun (Hanjun Guo)" <guohanjun@huawei.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "fu.wei@linaro.org" <fu.wei@linaro.org>, Gabriele Paoloni <gabriele.paoloni@huawei.com>, "zjzhang@codeaurora.org" <zjzhang@codeaurora.org>, "linux@armlinux.org.uk" <linux@armlinux.org.uk>, "wangxiongfeng (C)" <wangxiongfeng2@huawei.com>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "eun.taik.lee@samsung.com" <eun.taik.lee@samsung.com>, shijie.huang@arm.com
List-Id: linux-efi@vger.kernel.org

On Mon, 27 Feb 2017 13:58:19 -0500
Paul Gortmaker <paul.gortmaker@windriver.com> wrote:


> > --- a/drivers/acpi/apei/Kconfig
> > +++ b/drivers/acpi/apei/Kconfig
> > @@ -1,6 +1,15 @@
> >  config HAVE_ACPI_APEI
> >  	bool
> >  
> > +config HAVE_ACPI_APEI_GSIV
> > +        bool "APEI GSIV(Global System Interrupt) logging/recovering support"
> > +        depends on ACPI_APEI && ACPI_APEI_GHES
> > +        help
> > +          This option should be enabled if the system supports
> > +          firmware first handling of GSIV (Global System Interrupt)
> > +	  for the hardware errors and allows OS to do error
> > +          recovery/logging.
> > +
> >  config HAVE_ACPI_APEI_NMI
> >  	bool  
> 
> A "config HAVE_<foo>" option normally doesn't have a "help" section
> since it isn't meant to be user selected.  You can see that in the other
> two options that exist right here in the context of your patch.

I will argue that having "help" messages for even configs that do not
get selected are useful. It helps reviewers of the code to know why one
of these events should be enabled or not.


> 
> Also your Cc list here seems rather large; not sure how you came up with
> such a large list...

+1

-- Steve
