From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH v1 1/4] x86/cpu: Introduce INTEL_CPU_FAM*_NODATA() helper
 macros
Date: Fri, 31 Aug 2018 18:51:04 +0300
Message-ID: <20180831155104.GZ11447@smile.fi.intel.com>
References: <20180831091018.17543-1-andriy.shevchenko@linux.intel.com>
 <87mut2pmqf.fsf@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87mut2pmqf.fsf@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andi Kleen <ak@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Fri, Aug 31, 2018 at 08:41:28AM -0700, Andi Kleen wrote:
> Andy Shevchenko <andriy.shevchenko@linux.intel.com> writes:
> > +
> > +#define INTEL_CPU_FAM_ANY_NODATA(_family, _model)		\
> > +	INTEL_CPU_FAM_ANY(_family, _model, NULL)
> > +
> > +#define INTEL_CPU_FAM6_NODATA(_model)				\
> > +	INTEL_CPU_FAM_ANY_NODATA(6, INTEL_FAM6_##_model)

> _NODATA is actually longer than passing NULL ?

One character longer (you have to compare to ", NULL").

> Seems unnecessary

Let's gather other's opinions.

P.S. In any case some refactoring is needed to allow NULL in parameters (move &
out from base macro).

-- 
With Best Regards,
Andy Shevchenko
