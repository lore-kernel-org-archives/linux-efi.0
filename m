From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Subject: Re: [PATCH] rtc: Disable EFI rtc for x86
Date: Mon, 10 Nov 2014 11:45:06 -0500
Message-ID: <5460EB92.1090501@gmail.com>
References: <1412339576-17972-1-git-send-email-matt@console-pimps.org> <20141109182231.GA29337@pd.tnic> <1415618533.14686.239.camel@mfleming-mobl1.ger.corp.intel.com> <201411101723.49197@pali>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms020105030201000609040506"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201411101723.49197@pali>
Sender: linux-kernel-owner@vger.kernel.org
To: =?UTF-8?B?UGFsaSBSb2jDoXI=?= <pali.rohar@gmail.com>, Matt Fleming <matt.fleming@intel.com>
Cc: Borislav Petkov <bp@alien8.de>, Mark Salter <msalter@redhat.com>, Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Dave Young <dyoung@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Matthew Garrett <mjg59@srcf.ucam.org>
List-Id: linux-efi@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms020105030201000609040506
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2014-11-10 11:23, Pali Roh=C3=A1r wrote:
> On Monday 10 November 2014 12:22:13 Matt Fleming wrote:
>> On Sun, 2014-11-09 at 19:22 +0100, Borislav Petkov wrote:
>>> On Sun, Nov 09, 2014 at 06:37:46PM +0100, Pali Roh=C3=A1r wrote:
>>>> this patch totally disabled efi rfc driver on x86 machines
>>>> at compile time. But on some x86 machines it working
>>>> without crash and reading from file
>>>> /sys/class/rtc/rtc*/since_epoch returns correct
>>>> information. So why to disable compiling driver on
>>>> machines where driver working?
>>>
>>> Sounds like we need an efi=3Drtc_enable knob for people who
>>> what to use it...
>>
>> I'm not so sure. By and large, the EFI runtime Time services
>> just don't work very well on x86. Just because they work
>> sometimes, doesn't actually mean it's a good idea to use
>> them.
>>
>> The one scenario where the time services are useful is early
>> on during boot when we want to get the timezone information.
>> I have vague recollections of someone working on that.
>
> On laptop Dell Latitude E6440 with 64bit kernel 3.17-rc6 (where
> was rtc-efi.ko enabled at compile time for x86) it working fine
> without crash. So I think that other Dell machines could work
> too.
>
I can also confirm that it works correctly on a number of ASUS and=20
ASrock desktop motherboards with the most recent BIOS updates, and on a=20
Lenovo Thinkpad L540.  I can however confirm that it DOES NOT work=20
however on an Acer Aspire V5-131 system, though I had never updated the=20
BIOS on that one, so it may work correctly with a newer BIOS version.
> Maybe problems which were reported are only specific for 32bit
> UEFI? Or 32bit kernels?
>
> And I think that if I know that efi time service working on
> machine, I should be able to use it with mainline kernel (without
> hacking Kconfig to enable it and so...).
>
I agree, without it you need PC CMOS RTC support to access the RTC on=20
most systems, which in turn means that you have to enable the CSM in the =

EFI firmware, which is annoying cause you can't easily dual boot windows =

with secure boot when the CSM is enabled.


--------------ms020105030201000609040506
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIFuDCC
BbQwggOcoAMCAQICAw9gVDANBgkqhkiG9w0BAQ0FADB5MRAwDgYDVQQKEwdSb290IENBMR4w
HAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2lnbmlu
ZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZzAeFw0xNDA4
MDgxMTMwNDRaFw0xNTAyMDQxMTMwNDRaMGMxGDAWBgNVBAMTD0NBY2VydCBXb1QgVXNlcjEj
MCEGCSqGSIb3DQEJARYUYWhmZXJyb2luN0BnbWFpbC5jb20xIjAgBgkqhkiG9w0BCQEWE2Fo
ZW1tZWxnQG9oaW9ndC5jb20wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDdmm8R
BM5D6fGiB6rpogPZbLYu6CkU6834rcJepfmxKnLarYUYM593/VGygfaaHAyuc8qLaRA3u1M0
Qp29flqmhv1VDTBZ+zFu6JgHjTDniBii1KOZRo0qV3jC5NvaS8KUM67+eQBjm29LhBWVi3+e
a8jLxmogFXV0NGej+GHIr5zA9qKz2WJOEoGh0EfqZ2MQTmozcGI43/oqIYhRj8fRMkWXLUAF
WsLzPQMpK19hD8fqwlxQWhBV8gsGRG54K5pyaQsjne7m89SF5M8JkNJPH39tHEvfv2Vhf7EM
Y4WGyhLAULSlym1AI1uUHR1FfJaj3AChaEJZli/AdajYsqc7AgMBAAGjggFZMIIBVTAMBgNV
HRMBAf8EAjAAMFYGCWCGSAGG+EIBDQRJFkdUbyBnZXQgeW91ciBvd24gY2VydGlmaWNhdGUg
Zm9yIEZSRUUgaGVhZCBvdmVyIHRvIGh0dHA6Ly93d3cuQ0FjZXJ0Lm9yZzAOBgNVHQ8BAf8E
BAMCA6gwQAYDVR0lBDkwNwYIKwYBBQUHAwQGCCsGAQUFBwMCBgorBgEEAYI3CgMEBgorBgEE
AYI3CgMDBglghkgBhvhCBAEwMgYIKwYBBQUHAQEEJjAkMCIGCCsGAQUFBzABhhZodHRwOi8v
b2NzcC5jYWNlcnQub3JnMDEGA1UdHwQqMCgwJqAkoCKGIGh0dHA6Ly9jcmwuY2FjZXJ0Lm9y
Zy9yZXZva2UuY3JsMDQGA1UdEQQtMCuBFGFoZmVycm9pbjdAZ21haWwuY29tgRNhaGVtbWVs
Z0BvaGlvZ3QuY29tMA0GCSqGSIb3DQEBDQUAA4ICAQCr4klxcZU/PDRBpUtlb+d6JXl2dfto
OUP/6g19dpx6Ekt2pV1eujpIj5whh5KlCSPUgtHZI7BcksLSczQbxNDvRu6LNKqGJGvcp99k
cWL1Z6BsgtvxWKkOmy1vB+2aPfDiQQiMCCLAqXwHiNDZhSkwmGsJ7KHMWgF/dRVDnsl6aOQZ
jAcBMpUZxzA/bv4nY2PylVdqJWp9N7x86TF9sda1zRZiyUwy83eFTDNzefYPtc4MLppcaD4g
Wt8U6T2ffQfCWVzDirhg4WmDH3MybDItjkSB2/+pgGOS4lgtEBMHzAGQqQ+5PojTHRyqu9Jc
O59oIGrTaOtKV9nDeDtzNaQZgygJItJi9GoAl68AmIHxpS1rZUNV6X8ydFrEweFdRTVWhUEL
70Cnx84YBojXv01LYBSZaq18K8cERPLaIrUD2go+2ffjdE9ejvYDhNBllY+ufvRizIjQA1uC
OdktVAN6auQob94kOOsWpoMSrzHHvOvVW/kbokmKzaLtcs9+nJoL+vPi2AyzbaoQASVZYOGW
pE3daA0F5FJfcPZKCwd5wdnmT3dU1IRUxa5vMmgjP20lkfP8tCPtvZv2mmI2Nw5SaXNY4gVu
WQrvkV2in+TnGqgEIwUrLVbx9G6PSYZZs07czhO+Q1iVuKdAwjL/AYK0Us9v50acIzbl5CWw
ZGj3wjGCA6EwggOdAgEBMIGAMHkxEDAOBgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6
Ly93d3cuY2FjZXJ0Lm9yZzEiMCAGA1UEAxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEh
MB8GCSqGSIb3DQEJARYSc3VwcG9ydEBjYWNlcnQub3JnAgMPYFQwCQYFKw4DAhoFAKCCAfUw
GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTQxMTEwMTY0NTA2
WjAjBgkqhkiG9w0BCQQxFgQUKmYW/BnaBA096zNa5fSzHQUxKPIwbAYJKoZIhvcNAQkPMV8w
XTALBglghkgBZQMEASowCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIA
gDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDCBkQYJKwYBBAGCNxAE
MYGDMIGAMHkxEDAOBgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0
Lm9yZzEiMCAGA1UEAxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJ
ARYSc3VwcG9ydEBjYWNlcnQub3JnAgMPYFQwgZMGCyqGSIb3DQEJEAILMYGDoIGAMHkxEDAO
BgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0Lm9yZzEiMCAGA1UE
AxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJARYSc3VwcG9ydEBj
YWNlcnQub3JnAgMPYFQwDQYJKoZIhvcNAQEBBQAEggEAzLFP31mZJKW5KprL4Wu63TBHZIFz
5nsgL+rE6vPAd9S6RO2b1NIwzba0HZwS8Y8bQGHNMDRQvoXXyEAXhTDThaVVhFjg6JihAGer
zvsaDbIC5ulw7ELLLMCTe07w4REYuL9nkMTFmQmy7nNVH79Zg6hhFgo6yAtTDhMcJhen7ehe
kyG7isljUHws4xbEGRr1Y1WKwCF3X/ikEcgRjZK5kHHL6i5QSfASM2EY1ForKxjgi6yBr80w
ea6Bgj4ETP1aSdIRFo1MQeyPuIuBOv1uN5OPIk+N8bDEhckTwGkE6uFnQ+OOvisv2S8Em1xk
3BpduT/dRT6ZDp/Y7G+a21jWBgAAAAAAAA==
--------------ms020105030201000609040506--
