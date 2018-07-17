From: David Laight <David.Laight@ACULAB.COM>
Subject: RE: [PATCH v6 3/3] x86: paravirt: make native_save_fl extern inline
Date: Tue, 17 Jul 2018 08:44:46 +0000
Message-ID: <72ac0fad49214930a44f1e0288508e15@AcuMS.aculab.com>
References: <20180621162324.36656-1-ndesaulniers@google.com>
	<20180621162324.36656-4-ndesaulniers@google.com>
	<1e19dbef068b45a4a4e9eb4072e097be@AcuMS.aculab.com>
	<CAKwvOdmFVnSos71vAUnayuocBDhxLg76tvGF0y3sj+4+s7TCcw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <CAKwvOdmFVnSos71vAUnayuocBDhxLg76tvGF0y3sj+4+s7TCcw@mail.gmail.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: 'Nick Desaulniers' <ndesaulniers@google.com>
Cc: Kate Stewart <kstewart@linuxfoundation.org>, "andrea.parri@amarulasolutions.com" <andrea.parri@amarulasolutions.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "brijesh.singh@amd.com" <brijesh.singh@amd.com>, "J. Kiszka" <jan.kiszka@siemens.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Will Deacon <will.deacon@arm.com>, "jarkko.sakkinen@linux.intel.com" <jarkko.sakkinen@linux.intel.com>, "virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, Manoj Gupta <manojgupta@google.com>, "hpa@zytor.com" <hpa@zytor.com>, "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>, Thiebaud Weksteen <tweek@google.com>, "mawilcox@microsoft.com" <mawilcox@microsoft.com>, "x86@kernel.org" <x86@kernel.org>, "akataria@vmware.com" <akataria@vmware.com>, Greg Hackmann <ghackmann@google.com>
List-Id: linux-efi@vger.kernel.org

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

Please consider the environment and don't print this e-mail unless you really need to
