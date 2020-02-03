# AWS pre-production tests
# Example usage: sh preproduction_tests.sh <AWS_ACCESS_KEY_ID> <AWS_SECRET_ACCESS_KEY> <Release branch>
# For dewdrop, we created a dewdrop user on AWS
# sh preproduction_tests.sh AKIAIVGC2E6ITAPA5GGQ m5ShXFJ0QNVJspI7lzRovEnsYa6BzmXnZNGcUcYv R19-1

# Standalone
docker run -it -e AWS_ACCESS_KEY_ID=$1 -e AWS_SECRET_ACCESS_KEY=$2 -e TEMPLATE_URL=https://gitswarm.f5net.com/cloudsolutions/f5-cloud-factory/raw/$3/automated-test-scripts/f5-aws-cloudformation/supported/standalone/daily_test_bigiq.yaml -e TEMPLATE_PARAMETERS=data/f5-aws-cloudformation/supported/standalone/1nic/production-stack/bigiq/prepub_parameters.yaml -e STACK_TYPE='dewdrop-preproduction' -e ELASTIC_HOST='https://10.146.12.61/elastic/api'  -e SSH_KEY="-----BEGIN RSA PRIVATE KEY-----\nMIIEoQIBAAKCAQEAmYKGbBSPRg07IRkiYxpjaAWPfARW/rKy5Sq5Z0t3j9x/19qU mWgooYBFcslRBUwcc2v6nWvqj5Eykeqy8/0j5L1h8kDIMB4ZTaQ8Ccr/dDdrMTOP 9/WpH15q4AsqJgskwP4lvpO9zdR3iFwkRpMxiNTfGeJF4C4Q1SBPlpC++7C6TQNT 8QSmpb3W4XqVTi8xBNw1rweYMk3kPGhh0irWMwgIM/pMxQFfMLykXHpr//xffcat SEZ1+URomUxC08hJqJ8IeyG/Jft18Z9Jm5ZreWRyAJEe0OuIgZ+gIzxFC0DfIi8V FIOM3HFdx+nlJT0O91uMmkWWoIs8PCvJGEUZ+QIBJQKCAQAEJh9PB3l+bw9vmOVA 8uAXkXKUpivdXsaQknO2rwM7PU+QNlcLEKcm9aEDGjKfRz8KCdZXSBsYow80YEoG mCOQj38wD5a1MT70QrWDuWDZoKIIP6nx8eH57cuJg8LebwD+TA7boyDONiy+fwfm O1RdpONvZvr4OJir0HDajkpZ1E0xcMAGfeoZ9SkZ2BhDS2ZUO0cIbTvP0V3/1YLy 93xfTbLpWiQb7OYbYhJw/NQPE577j/lTYxMDCob6wMaly+4JJNRa7p8H/4HJwmdX NbZqyPwNBNc72l/l6oqfSXTdOCRLlQa8tgklORWP3NmV8Xn2s5tYuDEzO6Jjw7n4 sO1BAoGBAOq/XSj3xlWRhmaRjfWloTiuSxw6Q+24pnP69n1wXh4+Herbf1qdWWyS zW7xkPwM8/Njt7OPecG6sGOXRR7qzevycgR2ceIlsTfnuo0DDuUwBA6LEf6fopYC 2RbaDkP+YyiM2paCD0iZEOC1PAfeFwb1JUg32ejycl7vMPCWoY7bAoGBAKdoWmoJ C3tTyH+TsR3uqC4p/9U8+gVwZNpHlfdEB74ur0Gec7oearCowosWXsnFMnG+P/Cr evTODoLEKm3ygPZj2lLgMuDYXHvgy8z9xCjaU/WTzASKuRZD4IBDkB0TwHeoyoVM JPHiIF9HwmqbP2daQNCPzJFGemThsPeQEUC7AoGAeIvIDh5e7auYCygmTbXrAW5C Pu181ATf2rFOJL0paXnYAvsX4mx6B1JN0S/wgW5vbyVeVUmtOfgVY5LeTiWMVpFB d+nLxygcu9fcVj/XN2uvDmMXFAzJHJmtv6BoMMDmz6JGu/2ZJUeuuJRq70iIXYTN 9KcPCOszz+KclziYJsMCgYEAnlvLJgiOUhD77k1wMRIwYwUib8QPGebb8RNIq6E3 wb11Wb9mjXa38zfanz6ssQalVtaPgsu5f8nWYAWrmG/GGYEMyu/BbOhXfBnVio8v LZBBlUaeZSlHTGm4sK6dFJYkxDfiKxCtU4LgWiFJNGlXpvSCgBlSzpydSqv6baP0 pQMCgYBV6wI8WvUHE98otFo/yZo6b9LCphSIbRSHpw4irdcPGnUyM1ZLZ8Hx6mwI WRAMTRUKONN+jxD3ooyufE21EKvRxuIJjoQZKhiiwemkeeU9Bi9jgDzD3BmJrmdw xnKqsmAzMQjqUvt/V4KQLcJP4zR8a9yq8KfeYpVrYbtBGBpWgQ==\n-----END RSA PRIVATE KEY-----\n" artifactory.f5net.com/ecosystems-cloudsolutions-docker-dev/dewdrop:latest

docker run -it -e AWS_ACCESS_KEY_ID=$1 -e AWS_SECRET_ACCESS_KEY=$2 -e TEMPLATE_URL=https://gitswarm.f5net.com/cloudsolutions/f5-cloud-factory/raw/$3/automated-test-scripts/f5-aws-cloudformation/supported/standalone/daily_test_byol_or_payg.yaml -e TEMPLATE_PARAMETERS=data/f5-aws-cloudformation/supported/standalone/2nic/existing-stack/payg/prepub_parameters.yaml -e STACK_TYPE='dewdrop-preproduction' -e ELASTIC_HOST='https://10.146.12.61/elastic/api'  -e SSH_KEY="-----BEGIN RSA PRIVATE KEY-----\nMIIEoQIBAAKCAQEAmYKGbBSPRg07IRkiYxpjaAWPfARW/rKy5Sq5Z0t3j9x/19qU mWgooYBFcslRBUwcc2v6nWvqj5Eykeqy8/0j5L1h8kDIMB4ZTaQ8Ccr/dDdrMTOP 9/WpH15q4AsqJgskwP4lvpO9zdR3iFwkRpMxiNTfGeJF4C4Q1SBPlpC++7C6TQNT 8QSmpb3W4XqVTi8xBNw1rweYMk3kPGhh0irWMwgIM/pMxQFfMLykXHpr//xffcat SEZ1+URomUxC08hJqJ8IeyG/Jft18Z9Jm5ZreWRyAJEe0OuIgZ+gIzxFC0DfIi8V FIOM3HFdx+nlJT0O91uMmkWWoIs8PCvJGEUZ+QIBJQKCAQAEJh9PB3l+bw9vmOVA 8uAXkXKUpivdXsaQknO2rwM7PU+QNlcLEKcm9aEDGjKfRz8KCdZXSBsYow80YEoG mCOQj38wD5a1MT70QrWDuWDZoKIIP6nx8eH57cuJg8LebwD+TA7boyDONiy+fwfm O1RdpONvZvr4OJir0HDajkpZ1E0xcMAGfeoZ9SkZ2BhDS2ZUO0cIbTvP0V3/1YLy 93xfTbLpWiQb7OYbYhJw/NQPE577j/lTYxMDCob6wMaly+4JJNRa7p8H/4HJwmdX NbZqyPwNBNc72l/l6oqfSXTdOCRLlQa8tgklORWP3NmV8Xn2s5tYuDEzO6Jjw7n4 sO1BAoGBAOq/XSj3xlWRhmaRjfWloTiuSxw6Q+24pnP69n1wXh4+Herbf1qdWWyS zW7xkPwM8/Njt7OPecG6sGOXRR7qzevycgR2ceIlsTfnuo0DDuUwBA6LEf6fopYC 2RbaDkP+YyiM2paCD0iZEOC1PAfeFwb1JUg32ejycl7vMPCWoY7bAoGBAKdoWmoJ C3tTyH+TsR3uqC4p/9U8+gVwZNpHlfdEB74ur0Gec7oearCowosWXsnFMnG+P/Cr evTODoLEKm3ygPZj2lLgMuDYXHvgy8z9xCjaU/WTzASKuRZD4IBDkB0TwHeoyoVM JPHiIF9HwmqbP2daQNCPzJFGemThsPeQEUC7AoGAeIvIDh5e7auYCygmTbXrAW5C Pu181ATf2rFOJL0paXnYAvsX4mx6B1JN0S/wgW5vbyVeVUmtOfgVY5LeTiWMVpFB d+nLxygcu9fcVj/XN2uvDmMXFAzJHJmtv6BoMMDmz6JGu/2ZJUeuuJRq70iIXYTN 9KcPCOszz+KclziYJsMCgYEAnlvLJgiOUhD77k1wMRIwYwUib8QPGebb8RNIq6E3 wb11Wb9mjXa38zfanz6ssQalVtaPgsu5f8nWYAWrmG/GGYEMyu/BbOhXfBnVio8v LZBBlUaeZSlHTGm4sK6dFJYkxDfiKxCtU4LgWiFJNGlXpvSCgBlSzpydSqv6baP0 pQMCgYBV6wI8WvUHE98otFo/yZo6b9LCphSIbRSHpw4irdcPGnUyM1ZLZ8Hx6mwI WRAMTRUKONN+jxD3ooyufE21EKvRxuIJjoQZKhiiwemkeeU9Bi9jgDzD3BmJrmdw xnKqsmAzMQjqUvt/V4KQLcJP4zR8a9yq8KfeYpVrYbtBGBpWgQ==\n-----END RSA PRIVATE KEY-----\n" artifactory.f5net.com/ecosystems-cloudsolutions-docker-dev/dewdrop:latest

docker run -it -e AWS_ACCESS_KEY_ID=$1 -e AWS_SECRET_ACCESS_KEY=$2 -e TEMPLATE_URL=https://gitswarm.f5net.com/cloudsolutions/f5-cloud-factory/raw/$3/automated-test-scripts/f5-aws-cloudformation/supported/standalone/daily_test_bigiq.yaml -e TEMPLATE_PARAMETERS=data/f5-aws-cloudformation/supported/standalone/3nic/production-stack/bigiq/prepub_parameters.yaml -e STACK_TYPE='dewdrop-preproduction' -e ELASTIC_HOST='https://10.146.12.61/elastic/api'  -e SSH_KEY="-----BEGIN RSA PRIVATE KEY-----\nMIIEoQIBAAKCAQEAmYKGbBSPRg07IRkiYxpjaAWPfARW/rKy5Sq5Z0t3j9x/19qU mWgooYBFcslRBUwcc2v6nWvqj5Eykeqy8/0j5L1h8kDIMB4ZTaQ8Ccr/dDdrMTOP 9/WpH15q4AsqJgskwP4lvpO9zdR3iFwkRpMxiNTfGeJF4C4Q1SBPlpC++7C6TQNT 8QSmpb3W4XqVTi8xBNw1rweYMk3kPGhh0irWMwgIM/pMxQFfMLykXHpr//xffcat SEZ1+URomUxC08hJqJ8IeyG/Jft18Z9Jm5ZreWRyAJEe0OuIgZ+gIzxFC0DfIi8V FIOM3HFdx+nlJT0O91uMmkWWoIs8PCvJGEUZ+QIBJQKCAQAEJh9PB3l+bw9vmOVA 8uAXkXKUpivdXsaQknO2rwM7PU+QNlcLEKcm9aEDGjKfRz8KCdZXSBsYow80YEoG mCOQj38wD5a1MT70QrWDuWDZoKIIP6nx8eH57cuJg8LebwD+TA7boyDONiy+fwfm O1RdpONvZvr4OJir0HDajkpZ1E0xcMAGfeoZ9SkZ2BhDS2ZUO0cIbTvP0V3/1YLy 93xfTbLpWiQb7OYbYhJw/NQPE577j/lTYxMDCob6wMaly+4JJNRa7p8H/4HJwmdX NbZqyPwNBNc72l/l6oqfSXTdOCRLlQa8tgklORWP3NmV8Xn2s5tYuDEzO6Jjw7n4 sO1BAoGBAOq/XSj3xlWRhmaRjfWloTiuSxw6Q+24pnP69n1wXh4+Herbf1qdWWyS zW7xkPwM8/Njt7OPecG6sGOXRR7qzevycgR2ceIlsTfnuo0DDuUwBA6LEf6fopYC 2RbaDkP+YyiM2paCD0iZEOC1PAfeFwb1JUg32ejycl7vMPCWoY7bAoGBAKdoWmoJ C3tTyH+TsR3uqC4p/9U8+gVwZNpHlfdEB74ur0Gec7oearCowosWXsnFMnG+P/Cr evTODoLEKm3ygPZj2lLgMuDYXHvgy8z9xCjaU/WTzASKuRZD4IBDkB0TwHeoyoVM JPHiIF9HwmqbP2daQNCPzJFGemThsPeQEUC7AoGAeIvIDh5e7auYCygmTbXrAW5C Pu181ATf2rFOJL0paXnYAvsX4mx6B1JN0S/wgW5vbyVeVUmtOfgVY5LeTiWMVpFB d+nLxygcu9fcVj/XN2uvDmMXFAzJHJmtv6BoMMDmz6JGu/2ZJUeuuJRq70iIXYTN 9KcPCOszz+KclziYJsMCgYEAnlvLJgiOUhD77k1wMRIwYwUib8QPGebb8RNIq6E3 wb11Wb9mjXa38zfanz6ssQalVtaPgsu5f8nWYAWrmG/GGYEMyu/BbOhXfBnVio8v LZBBlUaeZSlHTGm4sK6dFJYkxDfiKxCtU4LgWiFJNGlXpvSCgBlSzpydSqv6baP0 pQMCgYBV6wI8WvUHE98otFo/yZo6b9LCphSIbRSHpw4irdcPGnUyM1ZLZ8Hx6mwI WRAMTRUKONN+jxD3ooyufE21EKvRxuIJjoQZKhiiwemkeeU9Bi9jgDzD3BmJrmdw xnKqsmAzMQjqUvt/V4KQLcJP4zR8a9yq8KfeYpVrYbtBGBpWgQ==\n-----END RSA PRIVATE KEY-----\n" artifactory.f5net.com/ecosystems-cloudsolutions-docker-dev/dewdrop:latest

docker run -it -e AWS_ACCESS_KEY_ID=$1 -e AWS_SECRET_ACCESS_KEY=$2 -e TEMPLATE_URL=https://gitswarm.f5net.com/cloudsolutions/f5-cloud-factory/raw/$3/automated-test-scripts/f5-aws-cloudformation/supported/standalone/daily_test_byol_or_payg.yaml -e TEMPLATE_PARAMETERS=data/f5-aws-cloudformation/supported/standalone/nnic/existing-stack/payg/prepub_parameters.yaml -e STACK_TYPE='dewdrop-preproduction' -e ELASTIC_HOST='https://10.146.12.61/elastic/api' -e SSH_KEY="-----BEGIN RSA PRIVATE KEY-----\nMIIEoQIBAAKCAQEAmYKGbBSPRg07IRkiYxpjaAWPfARW/rKy5Sq5Z0t3j9x/19qU mWgooYBFcslRBUwcc2v6nWvqj5Eykeqy8/0j5L1h8kDIMB4ZTaQ8Ccr/dDdrMTOP 9/WpH15q4AsqJgskwP4lvpO9zdR3iFwkRpMxiNTfGeJF4C4Q1SBPlpC++7C6TQNT 8QSmpb3W4XqVTi8xBNw1rweYMk3kPGhh0irWMwgIM/pMxQFfMLykXHpr//xffcat SEZ1+URomUxC08hJqJ8IeyG/Jft18Z9Jm5ZreWRyAJEe0OuIgZ+gIzxFC0DfIi8V FIOM3HFdx+nlJT0O91uMmkWWoIs8PCvJGEUZ+QIBJQKCAQAEJh9PB3l+bw9vmOVA 8uAXkXKUpivdXsaQknO2rwM7PU+QNlcLEKcm9aEDGjKfRz8KCdZXSBsYow80YEoG mCOQj38wD5a1MT70QrWDuWDZoKIIP6nx8eH57cuJg8LebwD+TA7boyDONiy+fwfm O1RdpONvZvr4OJir0HDajkpZ1E0xcMAGfeoZ9SkZ2BhDS2ZUO0cIbTvP0V3/1YLy 93xfTbLpWiQb7OYbYhJw/NQPE577j/lTYxMDCob6wMaly+4JJNRa7p8H/4HJwmdX NbZqyPwNBNc72l/l6oqfSXTdOCRLlQa8tgklORWP3NmV8Xn2s5tYuDEzO6Jjw7n4 sO1BAoGBAOq/XSj3xlWRhmaRjfWloTiuSxw6Q+24pnP69n1wXh4+Herbf1qdWWyS zW7xkPwM8/Njt7OPecG6sGOXRR7qzevycgR2ceIlsTfnuo0DDuUwBA6LEf6fopYC 2RbaDkP+YyiM2paCD0iZEOC1PAfeFwb1JUg32ejycl7vMPCWoY7bAoGBAKdoWmoJ C3tTyH+TsR3uqC4p/9U8+gVwZNpHlfdEB74ur0Gec7oearCowosWXsnFMnG+P/Cr evTODoLEKm3ygPZj2lLgMuDYXHvgy8z9xCjaU/WTzASKuRZD4IBDkB0TwHeoyoVM JPHiIF9HwmqbP2daQNCPzJFGemThsPeQEUC7AoGAeIvIDh5e7auYCygmTbXrAW5C Pu181ATf2rFOJL0paXnYAvsX4mx6B1JN0S/wgW5vbyVeVUmtOfgVY5LeTiWMVpFB d+nLxygcu9fcVj/XN2uvDmMXFAzJHJmtv6BoMMDmz6JGu/2ZJUeuuJRq70iIXYTN 9KcPCOszz+KclziYJsMCgYEAnlvLJgiOUhD77k1wMRIwYwUib8QPGebb8RNIq6E3 wb11Wb9mjXa38zfanz6ssQalVtaPgsu5f8nWYAWrmG/GGYEMyu/BbOhXfBnVio8v LZBBlUaeZSlHTGm4sK6dFJYkxDfiKxCtU4LgWiFJNGlXpvSCgBlSzpydSqv6baP0 pQMCgYBV6wI8WvUHE98otFo/yZo6b9LCphSIbRSHpw4irdcPGnUyM1ZLZ8Hx6mwI WRAMTRUKONN+jxD3ooyufE21EKvRxuIJjoQZKhiiwemkeeU9Bi9jgDzD3BmJrmdw xnKqsmAzMQjqUvt/V4KQLcJP4zR8a9yq8KfeYpVrYbtBGBpWgQ==\n-----END RSA PRIVATE KEY-----\n" artifactory.f5net.com/ecosystems-cloudsolutions-docker-dev/dewdrop:latest

# Failover
docker run -it -e AWS_ACCESS_KEY_ID=$1 -e AWS_SECRET_ACCESS_KEY=$2 -e TEMPLATE_URL=https://gitswarm.f5net.com/cloudsolutions/f5-cloud-factory/raw/$3/automated-test-scripts/f5-aws-cloudformation/supported/cluster/daily_test_byol_or_payg.yaml -e TEMPLATE_PARAMETERS=data/f5-aws-cloudformation/supported/failover/across-net/via-api/3nic/existing-stack/payg/prepub_parameters.yaml -e STACK_TYPE='dewdrop-preproduction' -e ELASTIC_HOST='https://10.146.12.61/elastic/api' -e SSH_KEY="-----BEGIN RSA PRIVATE KEY-----\nMIIEoQIBAAKCAQEAmYKGbBSPRg07IRkiYxpjaAWPfARW/rKy5Sq5Z0t3j9x/19qU mWgooYBFcslRBUwcc2v6nWvqj5Eykeqy8/0j5L1h8kDIMB4ZTaQ8Ccr/dDdrMTOP 9/WpH15q4AsqJgskwP4lvpO9zdR3iFwkRpMxiNTfGeJF4C4Q1SBPlpC++7C6TQNT 8QSmpb3W4XqVTi8xBNw1rweYMk3kPGhh0irWMwgIM/pMxQFfMLykXHpr//xffcat SEZ1+URomUxC08hJqJ8IeyG/Jft18Z9Jm5ZreWRyAJEe0OuIgZ+gIzxFC0DfIi8V FIOM3HFdx+nlJT0O91uMmkWWoIs8PCvJGEUZ+QIBJQKCAQAEJh9PB3l+bw9vmOVA 8uAXkXKUpivdXsaQknO2rwM7PU+QNlcLEKcm9aEDGjKfRz8KCdZXSBsYow80YEoG mCOQj38wD5a1MT70QrWDuWDZoKIIP6nx8eH57cuJg8LebwD+TA7boyDONiy+fwfm O1RdpONvZvr4OJir0HDajkpZ1E0xcMAGfeoZ9SkZ2BhDS2ZUO0cIbTvP0V3/1YLy 93xfTbLpWiQb7OYbYhJw/NQPE577j/lTYxMDCob6wMaly+4JJNRa7p8H/4HJwmdX NbZqyPwNBNc72l/l6oqfSXTdOCRLlQa8tgklORWP3NmV8Xn2s5tYuDEzO6Jjw7n4 sO1BAoGBAOq/XSj3xlWRhmaRjfWloTiuSxw6Q+24pnP69n1wXh4+Herbf1qdWWyS zW7xkPwM8/Njt7OPecG6sGOXRR7qzevycgR2ceIlsTfnuo0DDuUwBA6LEf6fopYC 2RbaDkP+YyiM2paCD0iZEOC1PAfeFwb1JUg32ejycl7vMPCWoY7bAoGBAKdoWmoJ C3tTyH+TsR3uqC4p/9U8+gVwZNpHlfdEB74ur0Gec7oearCowosWXsnFMnG+P/Cr evTODoLEKm3ygPZj2lLgMuDYXHvgy8z9xCjaU/WTzASKuRZD4IBDkB0TwHeoyoVM JPHiIF9HwmqbP2daQNCPzJFGemThsPeQEUC7AoGAeIvIDh5e7auYCygmTbXrAW5C Pu181ATf2rFOJL0paXnYAvsX4mx6B1JN0S/wgW5vbyVeVUmtOfgVY5LeTiWMVpFB d+nLxygcu9fcVj/XN2uvDmMXFAzJHJmtv6BoMMDmz6JGu/2ZJUeuuJRq70iIXYTN 9KcPCOszz+KclziYJsMCgYEAnlvLJgiOUhD77k1wMRIwYwUib8QPGebb8RNIq6E3 wb11Wb9mjXa38zfanz6ssQalVtaPgsu5f8nWYAWrmG/GGYEMyu/BbOhXfBnVio8v LZBBlUaeZSlHTGm4sK6dFJYkxDfiKxCtU4LgWiFJNGlXpvSCgBlSzpydSqv6baP0 pQMCgYBV6wI8WvUHE98otFo/yZo6b9LCphSIbRSHpw4irdcPGnUyM1ZLZ8Hx6mwI WRAMTRUKONN+jxD3ooyufE21EKvRxuIJjoQZKhiiwemkeeU9Bi9jgDzD3BmJrmdw xnKqsmAzMQjqUvt/V4KQLcJP4zR8a9yq8KfeYpVrYbtBGBpWgQ==\n-----END RSA PRIVATE KEY-----\n" artifactory.f5net.com/ecosystems-cloudsolutions-docker-dev/dewdrop:latest

# Autoscale
python dewdrop/dewdrop.py  -t https://gitswarm.f5net.com/cloudsolutions/f5-cloud-factory/raw/"$BRANCH"/automated-test-scripts/f5-aws-cloudformation/supported/standalone/daily_test.yaml -i data/f5-aws-cloudformation/supported/standalone/3nic/production-stack/payg/prepub_parameters.yaml -l http://localhost:9200 -d

python dewdrop/dewdrop.py  -t https://gitswarm.f5net.com/cloudsolutions/f5-cloud-factory/raw/"$BRANCH"/automated-test-scripts/f5-aws-cloudformation/supported/standalone/daily_test.yaml -i data/f5-aws-cloudformation/supported/standalone/2nic/existing-stack/byol/prepub_parameters.yaml -l http://localhost:9200 -d