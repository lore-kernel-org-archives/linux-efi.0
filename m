From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH v1 1/8] lib/uuid: Introduce uuid_{be|le}_cmp_p{p}() helpers
Date: Sun, 23 Apr 2017 15:42:35 +0300
Message-ID: <CAHp75VeTgdE=OiRNS6JrH3M-rF+jpPVgmd4G+n321=vhVE4XiA@mail.gmail.com>
References: <20170421144645.45189-1-andriy.shevchenko@linux.intel.com> <5B8DA87D05A7694D9FA63FD143655C1B543E8399@hasmsx108.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-input-owner@vger.kernel.org>
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B543E8399@hasmsx108.ger.corp.intel.com>
Sender: linux-input-owner@vger.kernel.org
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Mika Westerberg <mika.westerberg@linux.intel.com>, "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>, "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>, "Koul, Vinod" <vinod.koul@intel.com>, Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>Benjamin Tissoires <be>
List-Id: linux-efi@vger.kernel.org

On Sun, Apr 23, 2017 at 1:29 PM, Winkler, Tomas <tomas.winkler@intel.com> wrote:
>> New helpers take pointers to uuid_{be|le} as parameters.
>>
>> When using them on a raw data we don't need to do an ugly dereference and,
>> in some cases, a type casting.

> I think this going overboard, the _pp types  are just enough.
I looked at existing users and there are cases like
#define XXX_UUID UUID_...(a, b, c, ...)

uuid_.*_cmp(value, XXX_UUID)

For _pp variant if would be _cmp_pp(value, &XXX_UUID) which is
slightly worse than for _p variant.

-- 
With Best Regards,
Andy Shevchenko
