From: Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH v1 1/4] x86/cpu: Introduce INTEL_CPU_FAM*_NODATA() helper macros
Date: Fri, 31 Aug 2018 08:41:28 -0700
Message-ID: <87mut2pmqf.fsf@linux.intel.com>
References: <20180831091018.17543-1-andriy.shevchenko@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180831091018.17543-1-andriy.shevchenko@linux.intel.com> (Andy
        Shevchenko's message of "Fri, 31 Aug 2018 12:10:15 +0300")
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Andy Shevchenko <andriy.shevchenko@linux.intel.com> writes:
> +
> +#define INTEL_CPU_FAM_ANY_NODATA(_family, _model)		\
> +	INTEL_CPU_FAM_ANY(_family, _model, NULL)
> +
> +#define INTEL_CPU_FAM6_NODATA(_model)				\
> +	INTEL_CPU_FAM_ANY_NODATA(6, INTEL_FAM6_##_model)

_NODATA is actually longer than passing NULL ?

Seems unnecessary

-Andi
